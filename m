Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D307EC4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 20:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9806823B6C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 20:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgLRU15 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:27:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgLRU15 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Dec 2020 15:27:57 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC4C523B08;
        Fri, 18 Dec 2020 20:27:15 +0000 (UTC)
Date:   Fri, 18 Dec 2020 15:27:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 6/9] libtracefs man pages: APIs for working with files
 in trace instances.
Message-ID: <20201218152714.1b9eb000@gandalf.local.home>
In-Reply-To: <20201217094626.1402191-7-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
        <20201217094626.1402191-7-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Dec 2020 11:46:23 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Documented APIs:
> tracefs_file_exists()
> tracefs_dir_exists()
> tracefs_instance_get_file()
> tracefs_instance_get_dir()
> tracefs_instance_file_write()
> tracefs_instance_file_read()
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Documentation/libtracefs-instances-files.txt | 157 +++++++++++++++++++
>  1 file changed, 157 insertions(+)
>  create mode 100644 Documentation/libtracefs-instances-files.txt
> 
> diff --git a/Documentation/libtracefs-instances-files.txt b/Documentation/libtracefs-instances-files.txt
> new file mode 100644
> index 0000000..f1e9707
> --- /dev/null
> +++ b/Documentation/libtracefs-instances-files.txt
> @@ -0,0 +1,157 @@
> +libtracefs(3)
> +=============
> +
> +NAME
> +----
> +tracefs_file_exists, tracefs_dir_exists, tracefs_instance_get_file,
> +tracefs_instance_get_dir, tracefs_instance_file_write,
> +tracefs_instance_file_read - Work with files in tracing instances.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <tracefs.h>*
> +
> +bool *tracefs_file_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
> +bool *tracefs_dir_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
> +char pass:[*]*tracefs_instance_get_file*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
> +char pass:[*]*tracefs_instance_get_dir*(struct tracefs_instance pass:[*]_instance_);
> +int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
> +char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_file_, int pass:[*]_psize_);
> +
> +--
> +
> +DESCRIPTION
> +-----------
> +This set of APIs can be used to work with trace files in all trace instances.

> +All they have _instance_ argument, to limit the scope on the given trace _instance_ only.
> +If _instance_ is NULL, the scope is limited to the main trace instance.

Replace the above with:

  "Each of these APIs take an _instance_ argument, that can be NULL to act
  on the top level instance. Otherwise, it acts on an instance created with
  *tracefs_insance_create*(3)".

> +
> +The _tracefs_file_exists()_ function checks if a file with _name_ exists in _instance_.
> +
> +The _tracefs_dir_exists()_ function checks if a directory with _name_ exists in _instance_.
> +
> +The _tracefs_instance_get_file()_ function returns the full path of the file with
> +given _name_ in _instance_.

Should add: "Note, it does not check if the file exists in the instance".

> +
> +The _tracefs_instance_get_dir()_ function  returns the full path of the directory with
> +given _name_ in _instance_.

 "Note, it does not check if the directory exists in the instance."

> +
> +The _tracefs_instance_file_write()_ function writes a string _str_ in a _file_ from
> +the given _instance_, without the terminating NULL character.
> +
> +The _tracefs_instance_file_read()_ function reads the content of a _file_  from
> +the given _instance_.
> +
> +RETURN VALUE
> +------------
> +The _tracefs_file_exists()_ and  _tracefs_dir_exists()_ functions return true if the
> +file / directory exist in the given instance or false if they do not exist.

 "or false if it does not exist."

The "it" references the file or directory, not the functions, and "the"
makes it singular.

-- Steve


> +
> +The _tracefs_instance_get_file()_ and _tracefs_instance_get_dir()_ functions return
> +a string or NULL in case of an error. The returned string must be freed with
> +_tracefs_put_tracing_file()_.
> +
> +The _tracefs_instance_file_write()_ function returns the number of written bytes,
> +or -1 in case of an error.
> +
> +The _tracefs_instance_file_read()_ function returns a pointer to a NULL terminated
> +string, read from the file, or NULL in case of an error. The returned string must
> +be freed with free().
> +
