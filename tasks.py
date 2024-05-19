from invoke import task


@task()
def link_all(c):
    c.run("stow --verbose --target=$HOME --restow */")


@task()
def delete_all(c):
    c.run("stow --verbose --delete --target=$HOME */")
