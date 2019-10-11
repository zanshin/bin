# from http://nextmarvel.net/blog/2011/09/brew-install-postgresql-on-os-x-lion/
BREW_POSTGRES_DIR=`brew info postgres | awk '{print $1"/bin"}' | grep "/postgresql/"`
LION_POSTGRES_DIR=`which postgres | xargs dirname`
LION_PSQL_DIR=`which psql | xargs dirname`
 
sudo mkdir -p $LION_POSTGRES_DIR/archive
sudo mkdir -p $LION_PSQL_DIR/archive
 
for i in `ls $BREW_POSTGRES_DIR`
do
    if [ -f $LION_POSTGRES_DIR/$i ]
    then
        sudo mv $LION_POSTGRES_DIR/$i $LION_POSTGRES_DIR/archive/$i
        sudo ln -s $BREW_POSTGRES_DIR/$i $LION_POSTGRES_DIR/$i
    fi
 
    if [ -f $LION_PSQL_DIR/$i ]
    then
        sudo mv $LION_PSQL_DIR/$i $LION_PSQL_DIR/archive/$i
        sudo ln -s $BREW_POSTGRES_DIR/$i $LION_PSQL_DIR/$i
    fi
done
