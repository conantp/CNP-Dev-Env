echo -e "\nSetting up CNP development environment, with support for branch parameters.\n"

cnp_repo="https://github.com/DemocracyApps/CNP.git"
cnp_dir="cnp"
cnp_branch="$1"

json_repo="https://github.com/DemocracyApps/JSON.minify.git"
json_dir="JSON.minify"
json_parent_dir="cnp/src/vendor"
json_branch="$2"

echo "Repository URL:			$cnp_repo"
echo "Repository Directory:		$cnp_dir"

echo -e "\nChecking for existing directory"

# If the repository exists, do a pull
# Otherwise, do a git clone
if cd $cnp_dir; then 
	echo "Directory already exists"
	echo "Updating Repo" 
	git pull
else 
	if [ "$cnp_branch" != "" ]; then
		echo "Cloning Repo on branch $cnp_branch" 
		git clone -b $cnp_branch $cnp_repo $cnp_dir
	else
		echo "Cloning Repo" 
		git clone $cnp_repo $cnp_dir
	fi
	cd $cnp_dir
fi

if [ "$cnp_branch" != "" ]; then
	# Switch to the specified branch, even if we're already on it. 
	echo -e "\nChecking out branch: $cnp_branch"
	git checkout $cnp_branch
fi
cd ..

echo -e "\n\nProcessing JSON.minify repository"

cd $json_parent_dir

echo -e "Temporary fix: Cloning the JSON repository each time to make sure it exists."
git clone $json_repo $json_dir

echo -e "\nChecking for existing directory"

# If the repository exists, do a pull
# Otherwise, do a git clone
if cd $json_dir; then 
	echo "Directory already exists"
	echo "Updating Repo" 
	git pull
else 
	if [ "$json_branch" != "" ]; then
		echo "Cloning Repo on branch $json_branch" 
		git clone -b $json_branch $json_repo $json_dir
	else
		echo "Cloning Repo" 
		git clone $json_repo $json_dir
	fi
	cd $json_dir
fi

if [ "$json_branch" != "" ]; then
	# Switch to the specified branch, even if we're already on it. 
	echo -e "\nChecking out branch: $json_branch"
	git checkout $json_branch
	cd ..
fi

echo -e "\nFinished\n"