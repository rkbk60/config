function s -d 'echo $status'
    set -l last_status $status
    echo $last_status
    return $last_status
end
