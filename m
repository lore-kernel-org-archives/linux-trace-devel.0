Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:60416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727292AbeKGJaj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 04:30:39 -0500
Date: Tue, 6 Nov 2018 19:02:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tools/lib/traceevent: Implement libtraceevent man
 pages
Message-ID: <20181106190248.76b6cdec@gandalf.local.home>
In-Reply-To: <20181102145714.25885-4-tstoyanov@vmware.com>
References: <20181102145714.25885-1-tstoyanov@vmware.com>
        <20181102145714.25885-4-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


I noticed that you have the same subject for all the patches in this
set. They each need to be unique. State what man page is changing.

 tools/lib/traceevent: Add man pages for pid and comm APIs



On Fri, 2 Nov 2018 14:57:29 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch implements 5 new man pages, which describe following libtraceevent APIs:
> tep_register_comm,tep_pid_is_registered,tep_data_comm_from_pid,
> tep_data_pid_from_comm,tep_cmdline_pid,tep_alloc,tep_free,tep_get_long_size,
> tep_set_long_size,tep_set_flag.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../Documentation/libtraceevent-commands.txt  | 125 ++++++++++++++++++
>  .../Documentation/libtraceevent-handle.txt    |  77 +++++++++++
>  .../Documentation/libtraceevent-long_size.txt |  75 +++++++++++
>  .../Documentation/libtraceevent-ref.txt       |  84 ++++++++++++
>  .../Documentation/libtraceevent-set_flag.txt  |  94 +++++++++++++
>  5 files changed, 455 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-commands.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-handle.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-long_size.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-ref.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-commands.txt b/tools/lib/traceevent/Documentation/libtraceevent-commands.txt
> new file mode 100644
> index 000000000000..9ca6c19cf9cb
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-commands.txt
> @@ -0,0 +1,125 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_register_comm,tep_pid_is_registered,tep_data_comm_from_pid,tep_data_pid_from_comm,tep_cmdline_pid - handle pid to process name mappings
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +int *tep_register_comm*(struct tep_handle pass:[*]_tep_, const char pass:[*]_comm_, int _pid_);
> +int *tep_pid_is_registered*(struct tep_handle pass:[*]_tep_, int _pid_);
> +const char pass:[*]*tep_data_comm_from_pid*(struct tep_handle pass:[*]_pevent_, int _pid_);
> +struct cmdline pass:[*]*tep_data_pid_from_comm*(struct tep_handle pass:[*]_pevent_, const char pass:[*]_comm_, struct cmdline pass:[*]_next_);
> +int *tep_cmdline_pid*(struct tep_handle pass:[*]_pevent_, struct cmdline pass:[*]_cmdline_);
> +--
> +
> +DESCRIPTION
> +-----------
> +These functions can be used to handle the mapping between pid and process name. 
> +The library builds a cache of these mappings, which is used to display the name of 
> +the process, instead of its pid. This information can be retrieved from 
> +debugfs/tracing/saved_cmdlines file. It is also saved in trace.dat file. 

Instead of using debugfs/tracing, and use tracefs, as in
tracefs/saved_cmdlines, as tracefs can be mounted directly
in /sys/kernel/tracing, and debugfs doesn't even need to be configured
in.

> +
> +The _tep_register_comm()_ function registers a pid / process name mapping. 
> +The _pid_ argument is the process ID, the _comm_ argument is the process name, 
> +_tep_ is the event context. The process name string is duplicated.

"is duplicated"? Do you mean "copied"? Probably should just state, "The
_comm_ is copied internally."
 
> +
> +The _tep_pid_is_registered()_ function checks if a pid has a process name mapping registered. 
> +The _pid_ argumnet is the process ID, _tep_ is the event context.
> +
> +The _tep_data_comm_from_pid()_ function returns the process name for given pid.

  "for a given pid."

> +The _pid_ argument is the process ID, _tep_ is the event context. 

Probably should add, "The returned string should not be freed, but will
be freed when the _tep_ handler is closed.".

> +
> +The _tep_data_pid_from_comm()_ function returns pid for given process name.

 "returns a pid for a given"

Hmm, I think the "_data_" part of the name is confusing. I'll have to
remember to look at all the APIs and see what needs to be changed
again. But that's a conversation for another time.

> +The _comm_ argument is the process name, _tep_ is the event context. 
> +The argument _next_ is the cmdline structure to search for the next pid, can be NULL.

Remove the ", can be NULL". and end the sentence there.

> +As there may be more than one pid for a given process, the result of this call 
> +can be passed back into a recurring call in the _next_ parameter, to search for the next pid.

Add "If _next_ is NULL, it will return the first pid associated with
the _comm_".

> +The function performs a linear seach, so it may be slow.
> +
> +The _tep_cmdline_pid()_ function returns the pid associated with a given _cmdline_.
> +The _tep_ argument is the event context.

Hmm, having both "comm" and "cmdline" representing the same thing needs
to be addressed later as well.

> +
> +RETURN VALUE
> +------------
> +_tep_register_comm()_ function returns 0 on success completion, or -1 in case of a error.

Remove "completion" and change "of an error"


> +
> +_tep_pid_is_registered()_ function returns 1 if the _pid_ has a process name mapped to it, 0 otherwise.

We should change the above to be true or false.

> +
> +_tep_data_comm_from_pid()_ function returns the process name as string, or the string "<...>" if thers is no mapping for the given pid.

Typo:  "if there is"

> +
> +_tep_data_pid_from_comm()_ function returns pointer to struct cmdline, that holds a pid for a given

"returns a pointer to a struct cmdline"

Oh, and we missed a change. That needs to be struct tep_cmdline for
namespace issues.

> +process, or NULL if none is found. This result can be passed back into a recurring call as the _next_ parameter of the function.
> +
> +_tep_cmdline_pid()_ functions returns the pid for the give cmdline. If _cmdline_ is NULL, then
> + -1 is returned.
> + 
> +EXAMPLE
> +-------
> +The following example registers pid for command "ls", in context of event _tep_ 
> +and performs various searches for pid / process name mappings:
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +int ls_pid = 1021;
> +struct tep_handle *tep = tep_alloc();
> +...
> +	if (0 != tep_register_comm(tep, "ls", ls_pid)) {

BTW, please don't do the "(0 != xxx)" and "(0 == xxx)"

I know why teachers have taught this, but compilers will complain about
using "=" instead of "==" today, and the above just makes it horrible
to read. Who says "if zero equals xxx then ..."? We say "if xxx equals
zero then ...". Let's keep the logic to the English equivalent.



> +		/* Failed to register pid / command mapping */
> +	}
> +....
> +	if (0 == tep_pid_is_registered(tep, ls_pid)) {
> +		/* Command mapping for ls_pid is not registered */
> +	}
> +...
> +	const char *comm = tep_data_comm_from_pid(tep, ls_pid);
> +	if (comm) {
> +		/* Found process name for ls_pid */
> +	}
> +...	
> +	int pid;
> +	struct cmdline *cmd = tep_data_pid_from_comm(tep, "ls", NULL);
> +	while (cmd) {
> +		pid = tep_cmdline_pid(tep, cmd);
> +		/* Found pid for process "ls" */
> +		cmd = tep_data_pid_from_comm(tep, "ls", cmd);
> +	}
> +--
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltraceevent*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtraceevent(3)_, _trace-cmd(1)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtraceevent is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-handle.txt b/tools/lib/traceevent/Documentation/libtraceevent-handle.txt
> new file mode 100644
> index 000000000000..f6dcfad7b264
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-handle.txt
> @@ -0,0 +1,77 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_alloc,tep_free - Create / destroy trace event parser context.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +struct tep_handle pass:[*]*tep_alloc*(void);
> +void *tep_free*(struct tep_handle pass:[*]_tep_);
> +--
> +
> +DESCRIPTION
> +-----------
> +These are main functions to create and destroy tep_handle - the main structure, representing the trace event parser context. 

"These are the main"


> +This context is used as input parameter of all library APIs.

 "as the input parameter of most library APIs"

I think there's some that it is not used for.

> +
> +The _tep_alloc()_ functions allocates and initializes the tep context. It sets its reference counter to 1.

 "function allocates"

I would remove the text about the reference counter, as that is
explaining implementation and not use cases.

But we should add tep_ref() to this man page, and state something like:

_tep_ref()_ increments the reference to the _tep_ handle, allowing it
to be used by other transactions without worrying about another user
freeing it.

> +
> +The _tep_free()_ functions decrements the tep context reference counter by 1. When this counter reaches 0, the context is destroyed.

"The _tep_free()_ function will decrement the reference of the _tep_
handler. When there is no more references, then it will free the
handler, as well as clean up all its resources that it had used."


> +Before destroying, a full clean up is performed of all internal structures. 

> +The argument _tep_ is pointer to the trace event parser context.

 "is the pointer to the trace event .."

> +
> +RETURN VALUE
> +------------
> +_tep_alloc()_ returns pointer to newly created tep_handle structure. A NULL is returned in case there is not enough free memory to allocate it.

"returns a pointer to a newly" .. "NULL is returned on error." (remove
"A")

> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +
> +...
> +struct tep_handle *tep = tep_alloc();
> +
> +...
> +tep_free(tep);
> +...
> +--
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltraceevent*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtraceevent(3)_, _trace-cmd(1)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtraceevent is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-long_size.txt b/tools/lib/traceevent/Documentation/libtraceevent-long_size.txt
> new file mode 100644
> index 000000000000..327922e52af4
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-long_size.txt
> @@ -0,0 +1,75 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_get_long_size,tep_set_long_size - Get / set the size of of a long integer on the current machine, in bytes
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +int *tep_get_long_size*(strucqt tep_handle pass:[*]_tep_);
> +void *tep_set_long_size*(struct tep_handle pass:[*]_tep_, int _long_size_);
> +--
> +
> +DESCRIPTION
> +-----------
> +The _tep_get_long_size()_ function returns the size of a long integer on the current machine. 
> +The _tep_ argument is trace event parser context.
> +
> +The _tep_set_long_size()_ function sets the size of a long integer on the current machine.
> +The _tep_ argument is trace event parser context. The _long_size_ is the size of a long integer, in bytes. 
> +
> +RETURN VALUE
> +------------
> +The _tep_get_long_size()_ function returns the size of of a long integer on the current machine, in bytes.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +tep_set_long_size(tep, 4);
> +...
> +int long_size = tep_get_long_size(tep);
> +...
> +--
> +
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltraceevent*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtraceevent(3)_, _trace-cmd(1)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtraceevent is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-ref.txt b/tools/lib/traceevent/Documentation/libtraceevent-ref.txt
> new file mode 100644
> index 000000000000..ef0b6f0935d0
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-ref.txt
> @@ -0,0 +1,84 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_ref,tep_unref,tep_ref_get - Manage reference counter of trace event parser context.

I think it may be OK to combine this man page with the tep_alloc and
tep_free, as they are very much associated with them.

> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +void *tep_ref*(struct tep_handle pass:[*]_tep_);
> +void *tep_unref*(struct tep_handle pass:[*]_tep_);
> +int *tep_ref_get*(struct tep_handle pass:[*]_tep_);
> +--
> +
> +DESCRIPTION
> +-----------
> +These functions manage the reference counter of trace event parser context. When this counter reaches 0, the context is destroyed.
> +
> +The _tep_ref()_ function increments the reference counter of _tep_ by 1.
> +
> +The _tep_unref()_ function decrements the reference counter of _tep_ by 1. If this counter reaches 0, the context is destroyed.

Again, we don't want to really talk about reference counters. Simply
say adds a "reference" and "removes a reference" and that if
tep_unref() is called and removes the last reference, it will also free
the tep like tep_free().

> +
> +The _tep_ref_get()_ functions gets the current value of _tep_ reference counter.

Is there a tep_ref_get()?

-- Steve


> +
> +RETURN VALUE
> +------------
> +_tep_ref_get()_ returns the value of _tep_ reference counter. If _tep_ is NULL, 0 is returned.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> + ...
> +struct tep_handle *tep = tep_alloc();
> +if ( 1 != _tep_ref_get(tep)) {
> +	/* Something wrong happened, the counter must be 1 right after its creation */
> +}
> +
> +...
> +int ref = tep_ref_get(tep);
> +tep_ref(tep);
> +if ( (ref+1) != tep_ref_get(tep)) {
> +	/* Something wrong happened, the counter is not incremented by 1 */
> +}
> +tep_unref(tep);
> +...
> +--
> +
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltraceevent*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtraceevent(3)_, _trace-cmd(1)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtraceevent is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt b/tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt
> new file mode 100644
> index 000000000000..751814985b16
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt
> @@ -0,0 +1,94 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_set_flag - Set a flag or combination of flags of trace event parser context 
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +enum *tep_flag* {
> +	_TEP_NSEC_OUTPUT_,
> +	_TEP_DISABLE_SYS_PLUGINS_,
> +	_TEP_DISABLE_PLUGINS_
> +};
> +void *tep_set_flag*(struct tep_handle pass:[*]_tep_, int _flag_);
> +--
> +
> +DESCRIPTION
> +-----------
> +[verse]
> +--
> +The _tep_set_flag()_ function sets _flag_ or any combination of flags to _tep_ context.
> +Flags are defined in *enum tep_flag*:
> +	_TEP_NSEC_OUTPUT_ - print event's timestamp in nano seconds, instead of micro seconds.
> +	_TEP_DISABLE_SYS_PLUGINS_ - disable plugins, located in system's plugin directory. 
> +				This directory is defined at library compile time, and usually is
> +				depends on library installation prefix: (install_preffix)/lib/traceevent/plugins
> +	_TEP_DISABLE_PLUGINS_ - disable all library plugins: 
> +			 	- in system's plugin directory 
> +			 	- in directory, defined by the environment variable _TRACEEVENT_PLUGIN_DIR_
> +			 	- in user's home directory, _~/.traceevent/plugins_
> +
> +Note: plugin related flags must me set before calling _tep_load_plugins()_ API.
> +--
> +
> +RETURN VALUE
> +------------
> +_tep_set_flag()_ functions has no return value.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +/* Set printing of timestamps in nano seconds and disable system plugins */
> +tep_set_flag(tep, TEP_NSEC_OUTPUT | TEP_DISABLE_SYS_PLUGINS);
> +...
> +/* Disable all library plugins */
> +tep_set_flag(tep,  TEP_DISABLE_PLUGINS);
> +...
> +--
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the library APIs.
> +*trace-seq.h*
> +	Header file to include in order to have access to trace sequences related APIs.
> +	Trace sequences are used to allow a function to call several other functions 
> +	to create a string of data to use.
> +*-ltraceevent*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtraceevent(3)_, _trace-cmd(1)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtraceevent is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
