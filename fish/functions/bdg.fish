function bdg -d "if you are in git repository, then come back to git-root directory"
    success git rev-parse
        and cd (git rev-parse --show-toplevel)
        or  cd ..
    builtin pwd
end
