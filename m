Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 314E3C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BFE0611AE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhKDUbT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 16:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231484AbhKDUbS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 16:31:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1071661052;
        Thu,  4 Nov 2021 20:28:39 +0000 (UTC)
Date:   Thu, 4 Nov 2021 16:28:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 09/10] libtracefs: Update kprobes man pages
Message-ID: <20211104162837.0e987bd9@gandalf.local.home>
In-Reply-To: <20211104111047.302660-10-tz.stoyanov@gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
        <20211104111047.302660-10-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  4 Nov 2021 13:10:46 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> As there are a lot of changes in the libtracefs kprobes APIs, the
> documentation of the library should be updated.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Documentation/libtracefs-kprobes.txt | 111 +++++++++++++--------------
>  Documentation/libtracefs.txt         |   7 ++
>  2 files changed, 60 insertions(+), 58 deletions(-)
> 
> diff --git a/Documentation/libtracefs-kprobes.txt b/Documentation/libtracefs-kprobes.txt
> index c10576e..fedac96 100644
> --- a/Documentation/libtracefs-kprobes.txt
> +++ b/Documentation/libtracefs-kprobes.txt
> @@ -3,7 +3,9 @@ libtracefs(3)
>  
>  NAME
>  ----
> -tracefs_kprobe_raw, tracefs_kretprobe_raw, tracefs_get_kprobes, tracefs_kprobe_info, tracefs_kprobe_clear_all, tracefs_kprobe_clear_probe - Create, list, and destroy kprobes
> +tracefs_kprobe_alloc, tracefs_kretprobe_alloc, tracefs_kprobe_info,
> +tracefs_kprobe_raw, tracefs_kretprobe_raw - Allocate, get, and create kprobes
> +
>  
>  SYNOPSIS
>  --------
> @@ -11,18 +13,44 @@ SYNOPSIS
>  --
>  *#include <tracefs.h>*
>  
> -int tracefs_kprobe_raw(const char pass:[*]system, const char pass:[*]event, const char pass:[*]addr, const char pass:[*]format);
> -int tracefs_kretprobe_raw(const char pass:[*]system, const char pass:[*]event, const char pass:[*]addr, const char pass:[*]format);
> -char pass:[*]pass:[*]tracefs_get_kprobes(enum tracefs_kprobe_type type);
> -enum tracefs_kprobe_type tracefs_kprobe_info(const char pass:[*]group, const char pass:[*]event,
> -					     char pass:[*]pass:[*]type, char pass:[*]pass:[*]addr, char pass:[*]pass:[*]format);
> -enum tracefs_kprobe_type tracefs_kprobe_type(const char pass:[*]group, const char pass:[*]event)
> -int tracefs_kprobe_clear_all(bool force);
> -int tracefs_kprobe_clear_probe(const char pass:[*]system, const char pass:[*]event, bool force);
> +struct tracefs_dynevent pass:[*]
> +*tracefs_kprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_,
> +		       const char pass:[*]_addr_, const char pass:[*]_format_);
> +struct tracefs_dynevent pass:[*]
> +*tracefs_kretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_,
> +			  const char pass:[*]_addr_, const char pass:[*]_format_, int _max_);
> +enum tracefs_dynevent_type *tracefs_kprobe_info*(struct tracefs_dynevent pass:[*]_kprobe_,
> +						char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_,
> +						char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_,
> +						char pass:[*]pass:[*]_format_);
> +int *tracefs_kprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_,
> +			 const char pass:[*]_addr_, const char pass:[*]_format_);
> +int *tracefs_kretprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_,
> +			    const char pass:[*]_addr_, const char pass:[*]_format_);
>  --
>  
>  DESCRIPTION
>  -----------
> +*tracefs_kprobe_alloc*() allocates a new kprobe context. The kbrobe is not configured in the system.
> +The new kprobe will be in the _system_ group (or kprobes if _system_ is NULL). Have the name of

               "is NULL) and have the name of"

> +_event_ (or _addr_ if _event_ is NULL). Will be inserted to _addr_ (function name, with or without

Need proper grammar here:  "The kprobe will be inserted"

> +offset, or a address). And the _format_ will define the format of the kprobe. See the Linux

  "), and the _format_"

> +documentation file under: Documentation/trace/kprobetrace.rst
> +
> +*tracefs_kretprobe_alloc*() is the same as *tracefs_kprobe_alloc*, but allocates context for
> +kretprobe. It has one additional parameter, which is optional, _max_ - maxactive count.
> +See description of kretprobes in the Documentation/trace/kprobetrace.rst file.
> +
> +*tracefs_kprobe_info*() returns the type and information of a given _kprobe_. If any of the
> +_system_, _event_, _prefix_, _addr_ or _format_ arguments are not NULL, then strings are allocated
> +and returned back via these arguments. The _system_ and _event_ holds the system and the name of the
> +kprobe. If _prefix_ is non NULL, then it will hold an allocated string that holds the prefix portion
> +of the kprobe in the kprobe_events file (the content up to the ":", including it). Note that for
> +kretprobes, the max active count is encoded in the prefix srting. If _addr_ is non NULL, it will
> +hold the address or function that the kprobe is attached to. If _format_ is non NULL, it will hold
> +the format string of the kprobe. Note, that the content in _group_, _event_, _prefix_, _addr_, and
> +_format_ must be freed with free(3) if they are set.
> +
>  *tracefs_kprobe_raw*() will create a kprobe event. If _system_ is NULL, then
>  the default "kprobes" is used for the group (event system). Otherwise if _system_
>  is specified then the kprobe will be created under the group by that name. The
> @@ -36,55 +64,21 @@ document.
>  creates a kretprobe instead of a kprobe. The difference is also described
>  in the Linux kernel source in the Documentation/trace/kprobetrace.rst file.
>  
> -*tracefs_get_kprobes*() returns an array of strings (char pass:[*]) that contain
> -the registered kprobes and kretprobes depending on the given _type_. If _type_ is
> -TRACEFS_ALL_KPROBES, then all kprobes found are returned. If _type_ is
> -TRACEFS_KPROBE, then only normal kprobes are returned. If _type_ is
> -TRACEFS_KRETPROBE, then only kretprobes are returned.
> -The names are in the "system/event" format.
> -That is, one string holds both the kprobe's name as well as the group it is
> -defined under. These strings are allocated and may be modified with the
> -*strtok*(3) and *strtok_r*(3) functions. The string returned must be freed with
> -*tracefs_list_free*(3).
> -
> -*tracefs_kprobe_info*() returns the type of the given kprobe. If _group_ is
> -NULL, then the default "kprobes" is used. If _type_ is non NULL, then it will
> -hold an allocated string that holds the type portion of the kprobe in the
> -kprobe_events file (the content before the ":"). If _addr_ is non NULL, it will
> -hold the address or function that the kprobe is attached to. If _format_ is non
> -NULL, it will hold the format string of the kprobe. Note, that the content in
> -_type_, _addr_, and _format_ must be freed with free(3) if they are set. Even
> -in the case of an error, as they may hold information of what caused the error.
> -
> -*tracefs_kprobe_clear_all*() will try to remove all kprobes that have been
> -registered. If the @force flag is set, it will then disable those kprobe events
> -if they are enabled and then try to clear the kprobes.
> -
> -*tracefs_kprobe_clear_probe*() will try to clear specified kprobes. If _system_
> -is NULL, then it will only clear the default kprobes under the "kprobes" group.
> -If _event_ is NULL, it will clear all kprobes under the given _system_. If the
> -_force_ flag is set, then it will disable the given kprobe events before clearing
> -them.
> -
>  RETURN VALUE
>  ------------
>  
> -*tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*(), *tracefs_kprobe_clear_all*(),
> -and *tracefs_kprobe_clear_probe*() return 0 on success, or -1 on error.
> -
> -If a parsing error occurs on *tracefs_kprobe_raw*() or *tracefs_kretprobe_raw*()
> -then *tracefs_error_last*(3) may be used to retrieve the error message explaining
> -the parsing issue.
> +*tracefs_kprobe_raw*() and *tracefs_kretprobe_raw*() return 0 on success, or -1 on error.
> +If a parsing error occurs on *tracefs_kprobe_raw*() or *tracefs_kretprobe_raw*() then
> +*tracefs_error_last*(3) may be used to retrieve the error message explaining the parsing issue.
>  
> -*tracefs_get_kprobes*() returns an allocate string list of allocated strings
> -on success that must be freed with *tracefs_list_free*(3) and returns
> -NULL on error.
> +The *tracefs_kprobe_alloc*() and *tracefs_kretprobe_alloc*() APIs return pointer to allocated

  "APIs return a pointer to an allocated"

> +tracefs_dynevent structure, describing the probe. This pointer must be freed by
> +*tracefs_dynevent_free*(3).

 Add: "Note, this only allocates a descriptor representing the kprobe. It
      does not modify the running system."

>  
> -*tracefs_kprobe_info*() returns the type of the given kprobe. It returns
> -TRACEFS_KPROBE for normal kprobes, TRACEFS_KRETPROBE for kretprobes, and
> -on error, or if the kprobe is not found TRACEFS_ALL_KPROBES is returned.
> -If _type_, _addr_, or _format_ are non NULL, they will contain allocated
> -strings that must be freed by free(3) even in the case of error.
> +*tracefs_kprobe_info*() returns the type of the given kprobe. It returns TRACEFS_DYNEVENT_KPROBE for
> +normal kprobes, TRACEFS_DYNEVENT_KRETPROBE for kretprobes or TRACEFS_DYNEVENT_MAX on error.

I should have commented on this on the patch that implements this, but I
noticed it now. As TRACEFS_DYNEVENT_MAX may change in the future, we should
not use it for any API. And now that the enum represents bits, it an error
should return 0.

We can make: TRACFS_DYNEVENT_ERROR be zero in enum tracefs_dynevent_type.


> +If _system_, _event_, _prefix_, _addr_, or _format_ are non NULL, they will contain allocated
> +strings that must be freed by free(3).
>  
>  ERRORS
>  ------
> @@ -96,9 +90,10 @@ The following errors are for all the above calls:
>  
>  *ENOMEM* Memory allocation error.
>  
> -*tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*() can fail with the following errors:
> +*tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*(), *tracefs_kprobe_alloc*(),
> +and *tracefs_kretprobe_alloc*() can fail with the following errors:
>  
> -*EBADMSG* Either _addr_ or _format_ are NULL.
> +*EBADMSG* if _addr_ is NULL.
>  
>  *EINVAL*  Most likely a parsing error occurred (use *tracefs_error_last*(3) to possibly
>            see what that error was).
> @@ -217,7 +212,7 @@ int main (int argc, char **argv, char **env)
>  		exit(-1);
>  	}
>  
> -	tracefs_kprobe_clear_probe(mykprobe, NULL, true);
> +	tracefs_kprobe_destroy(NULL, true);

There is no tracefs_kprobe_destroy().

>  
>  	kprobe_create("open", "do_sys_openat2",
>  		      "file=+0($arg2):ustring flags=+0($arg3):x64 mode=+8($arg3):x64\n");
> @@ -247,7 +242,7 @@ int main (int argc, char **argv, char **env)
>  	} while (waitpid(pid, NULL, WNOHANG) != pid);
>  
>  	/* Will disable the events */
> -	tracefs_kprobe_clear_probe(mykprobe, NULL, true);
> +	tracefs_kprobe_destroy(NULL, true);

Here too.

-- Steve

>  	tracefs_instance_destroy(instance);
>  	tep_free(tep);
>  
> @@ -293,5 +288,5 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
>  
>  COPYING
>  -------
> -Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
> +Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
>  the terms of the GNU Public License (GPL).
> diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
> index 2c9eabd..f679002 100644
> --- a/Documentation/libtracefs.txt
> +++ b/Documentation/libtracefs.txt
> @@ -63,6 +63,13 @@ Writing data in the trace buffer:
>  
>  Control library logs:
>  	int *tracefs_set_loglevel*(enum tep_loglevel _level_);
> +
> +Kprobes and Kretprobes:
> +	struct tracefs_dynevent pass:[*] *tracefs_kprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
> +	struct tracefs_dynevent pass:[*] *tracefs_kretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_, int _max_);
> +	enum tracefs_kprobe_type *tracefs_kprobe_info*(struct tracefs_dynevent pass:[*]_kprobe_, char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_, char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_, char pass:[*]pass:[*]_format_);
> +	int *tracefs_kprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
> +	int *tracefs_kretprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
>  --
>  
>  DESCRIPTION

