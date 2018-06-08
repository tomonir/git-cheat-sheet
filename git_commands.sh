#!/bin/bash
# A shell script to summarize all useful alias command in a single place.



#how to use it:
#./git_commands.sh -help








 
# for arg in "$@"
# do
    # echo $arg
# done

# echo ${#2}

case $1 in
		-help)
			RED='\033[0;33m'
			NC='\033[0m' # No Color
			
			printf "${RED}-cbh${NC}			to see current branch history graph\n"
			printf "${RED}-search_log${NC}		to see all commits log that contains the search patern\n"
			printf "${RED}-commits_b_tag${NC}		to see all commits between tags\n"
			printf "${RED}-search_file${NC}		search file\n"
			printf "${RED}-diff_branch${NC}		to see the difference between local and remote branches\n"
			printf "${RED}-diff${NC}			to see the difference between tags in beyond comapare\n"
			printf "${RED}-diff_tag${NC}		to see tag difference between local and remote repository\n"
			printf "${RED}-push_tag${NC}		to push a tag\n"
			printf "${RED}-del_tag${NC}		to delete a tag\n"
			printf "${RED}-del_last_commit${NC}	to delete last commit from the current [unpushed]branch.\n"
			printf "${RED}-stash_list${NC}		to list all stash\n"
			printf "${RED}-stash_apply${NC}		to apply a stash to current branch\n"
			printf "${RED}-pull_update${NC}		to update all submodule recursively for the current branch\n"
			printf "${RED}-list_tags${NC}		to see all the tags of the current branch\n"
			
			;;

        -cbh)
                gitk&
                ;;
		-search_log)
		
				if [ ${#2} -gt 0 ]
                then
                    txt=$2
                else
                    echo "what to search?"
                    read txt
                fi
				
				git log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate  --all| grep $txt
				;;
		-commits_b_tag)
				echo "Your current branch is:"$(git rev-parse --abbrev-ref HEAD) "[ It should be release/ULFX.. ]"
				echo ""
				echo ""
				
				if [ ${#2} -gt 0 ]
                then
                    first_tag=$2
                else
                    echo "first tag?"
                    read first_tag
                fi

				if [ ${#3} -gt 0 ]
                then
                    second_tag=$3
                else
                    echo "second tag?"
                    read second_tag
                fi
				
				echo ""
				echo "=================================="
				echo "Dependent baseline:"
				git log $first_tag...$second_tag --decorate | grep -Eow 'tag: ([a-zA-Z0-9.-_]*)' | awk '{ print substr($0, 6); }'
				echo ""
				echo "=================================="
				echo "The changes:"
				git log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate  $first_tag...$second_tag
				;;		
		-search_file)
				echo "File name?"
				read txt
				echo "Please wait ..."
				tmpdir=$(mktemp -td git-find.XXXX)
				trap "rm -r $tmpdir" EXIT INT TERM

				allrevs=$(git rev-list --all)
				# well, nearly all revs, we could still check the log if we have
				# dangling commits and we could include the index to be perfect...

				for rev in $allrevs
				do
				  git ls-tree --full-tree -r $rev >$tmpdir/$rev 
				done

				cd $tmpdir
				grep $txt *
				;;
		-diff_tag)
                git push --tags --dry-run
                ;;
		-diff)
                if [ ${#2} -gt 0 ]
				then first_tag=$2
				else
					echo "first tag?"
					read first_tag
				fi
				if [ ${#3} -gt 0 ]
				then second_tag=$3
				else
					echo "second tag?"
					read second_tag
				fi
				
				first_tag_hash=$(git rev-list -n 1 $first_tag)
				second_tag_hash=$(git rev-list -n 1 $second_tag)
				git difftool -d --submodule=log $first_tag_hash $second_tag_hash
                ;;		
				
		-diff_branch)
				
				currbranch=$(git rev-parse --abbrev-ref HEAD)
				remote_branch='remotes/origin/'$currbranch
				echo 'Difference between '$currbranch 'and' $remote_branch '.....' 
				git diff $currbranch $remote_branch
				;;
        -push_tag)
		
				if [ ${#2} -gt 0 ]
                then
                    tag_name=$2
                else
                    echo "tag name?" 
                    read tag_name
                fi
				
				git push origin $tag_name
                ;;
		-del_tag)
				if [ ${#2} -gt 0 ]
                then
                    tag_name=$2
                else
                    echo "tag name?" 
                    read tag_name
                fi
				echo "Deleting from local repository...."
				git tag --delete $tag_name
				echo "Deleting from remote repository...."
				git push --delete origin $tag_name
                ;;
		-del_last_commit)
				git reset --hard HEAD^
				;;
		-stash_list)
				git stash list
				;;
	-stash_apply)
				echo "stash number stash@{n}, please only give the number?"
				read stash_no
				git stash apply $stash_no
				;;
	-pull_update)
				git pull && git submodule update --init --recursive
				;;
	-list_tags)
				if [ ${#2} -gt 0 ]
				then
					txt_to_filter=$2
					git log --decorate | grep -Eow 'tag: ([a-zA-Z0-9.-_]*)' | awk '{ print substr($0, 6); }' | grep $txt_to_filter
				else
					git log --decorate | grep -Eow 'tag: ([a-zA-Z0-9.-_]*)' | awk '{ print substr($0, 6); }'
				fi	
				 
				;;				
		





				

				
        *)
        	    echo "Command not found!, please use -help option"
                ;;
esac