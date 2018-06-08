# git-cheat-sheet

HOW TO RUN

Windows: 
1. copy git_commands.sh to your git repository.
2. open the git-bash.exe  from the following location [I assume git has been installed at C:\Program Files\Git\]
C:\Program Files\Git\git-bash.exe
3. go to the git repository using command line.
4. ./git_commands.sh -help 

OTHER OPTIONS:

-cbh                    
to see current branch history graph

-search_log             
to see all commits log that contains the search patern

-commits_b_tag          
to see all commits between tags

-search_file            
search file

-diff_branch            
to see the difference between local and remote branches

-diff_tag               
to see tag difference between local and remote repository

-push_tag               
to push a tag

-del_tag                
to delete a tag

-del_last_commit        
to delete last commit from the current [unpushed]branch.

-stash_list             
to list all stash

-stash_apply            
to apply a stash to current branch

-pull_update            
to update all submodule recursively for the current branch
