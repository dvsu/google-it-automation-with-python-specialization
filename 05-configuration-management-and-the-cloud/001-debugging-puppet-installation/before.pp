class profile {
  file { '/etc/profile.d/append-path.sh':
    owner => 'root',
    group => 'root',
    mode => '0646',
    content => "PATH=/java/bin\n",
  }
}
