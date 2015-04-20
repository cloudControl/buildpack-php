function framework_detection() {
  # Framework detection
  pushd $PROJECT_ROOT &> /dev/null
  FRAMEWORK=$($BIN_DIR/detect $PROJECT_ROOT)
  
  case $FRAMEWORK in
  
"PHP/Symfony1")
    echo "Symfony 1.x detected" | indent_head
    WEBCONTENT=${WEBCONTENT:-'web'}
    cp $BP_DIR/conf/symfony1.x.conf $APACHE_PATH/conf/share/50-symfony1.x.conf
    clean_directory cache
    ;;
"PHP/Symfony2")
    echo "Symfony 2.x detected" | indent_head
    WEBCONTENT=${WEBCONTENT:-'web'}
    clean_directory app/cache
    clean_directory app/logs
    ;;
"PHP/Zend1")
    echo "Zend 1.x Framework detected" | indent_head
    WEBCONTENT=${WEBCONTENT:-'public'}
    ;;
"PHP/Zend2")
    echo "Zend 2.x Framework detected" | indent_head
    WEBCONTENT=${WEBCONTENT:-'public'}
    ;;
"PHP/Yii")
    echo "Yii Framework detected" | indent_head
    for d in $(find . -maxdepth 1 -type d); do
      if [[ -f $d/index.php && -d $d/protected ]]; then
        webroot="$d"
      fi
    done
    WEBCONTENT=${WEBCONTENT:-$webroot}
    if [[ ! "$WEBCONTENT" ]]; then
      echo "ERROR: Failed to auto-detect web content." | indent
      exit 1
    fi
    if [[ ! -d $WEBCONTENT/protected/runtime ]]; then
      echo "Required directory missing, creating '$WEBCONTENT/protected/runtime'." | indent
      mkdir $PROJECT_ROOT/$WEBCONTENT/protected/runtime
    fi
    if [[ ! -d $WEBCONTENT/assets ]]; then
      echo "Required directory missing, creating '$WEBCONTENT/assets'." | indent
      mkdir $WEBCONTENT/assets
    fi
    ;;
"PHP/Kohana")
    echo "Kohana Framework detected" | indent_head
    WEBCONTENT=${WEBCONTENT:-''}
    clean_directory application/cache
    clean_directory application/logs
    ;;
"PHP/CakePhp")
    echo "CakePhp Framework detected" | indent_head
    if [[ ! -f app/Config/core.php ]]; then
      echo "ERROR: in order to run your application you need the configuration file. Please check your .gitignore file." | indent
      exit 1
    fi
    clean_directory app/tmp
  # this is the origin folder structure, that should be created
  # app/tmp/
  # ├── cache
  # │   ├── models
  # │   ├── persistent
  # │   └── views
  # ├── logs
  # ├── sessions
  # └── tests
    mkdir -p app/tmp/{logs,cache,sessions,tests}
    mkdir -p app/tmp/cache/{models,persistent,views}
    ;;
  *)
    WEBCONTENT=${WEBCONTENT:-''}
    ;;
  esac

  popd &> /dev/null
}
