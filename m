Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91ABBC4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 20:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C7252343F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 20:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbgLRUI4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:08:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728215AbgLRUIz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Dec 2020 15:08:55 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCAFB22C9D;
        Fri, 18 Dec 2020 20:08:14 +0000 (UTC)
Date:   Fri, 18 Dec 2020 15:08:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 5/9] libtracefs man pages: APIs for managing trace
 instances.
Message-ID: <20201218150813.5a7bbc9f@gandalf.local.home>
In-Reply-To: <20201217094626.1402191-6-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
        <20201217094626.1402191-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Dec 2020 11:46:22 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Documented APIs:
> tracefs_instance_create()
> tracefs_instance_destroy()
> tracefs_instance_free()
> tracefs_instance_is_new()
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Documentation/libtracefs-instances-manage.txt | 104 ++++++++++++++++++
>  1 file changed, 104 insertions(+)
>  create mode 100644 Documentation/libtracefs-instances-manage.txt
> 
> diff --git a/Documentation/libtracefs-instances-manage.txt b/Documentation/libtracefs-instances-manage.txt
> new file mode 100644
> index 0000000..ca08269
> --- /dev/null
> +++ b/Documentation/libtracefs-instances-manage.txt
> @@ -0,0 +1,104 @@
> +libtracefs(3)
> +=============
> +
> +NAME
> +----
> +tracefs_instance_create, tracefs_instance_destroy, tracefs_instance_free,
> +tracefs_instance_is_new - Manage trace instances.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <tracefs.h>*
> +
> +struct tracefs_instance pass:[*]*tracefs_instance_create*(const char pass:[*]_name_);
> +int *tracefs_instance_destroy*(struct tracefs_instance pass:[*]_instance_);
> +void *tracefs_instance_free*(struct tracefs_instance pass:[*]_instance_);
> +bool *tracefs_instance_is_new*(struct tracefs_instance pass:[*]_instance_);
> +
> +--
> +
> +DESCRIPTION
> +-----------
> +This set of functions can be used to manage trace instances.

We should add a description of what a trace instance is:

 "A trace instance is a sub buffer used by the Linux tracing system. Given
 a unique name, the events enabled in an instance do not affect the main
 tracing system, nor other instances, as events enabled in the main tracing
 system or other instances do not affect the given instance."



> +
> +The _tracefs_instance_create()_ function creates a new trace instance with given
> +_name_, if it does not already exist in the system. It allocates and initializes
> +a new tracefs_instance structure and returns it.

The above description is a little ambiguous to what happen if the instance
already exists in the system. Perhaps reword the above to:

 "The _tracefs_instance_create()_ function allocates and initializes a new
 tracefs_instance structure and returns it. If the instance does not yet
 exist in the system, it will be created."

> +
> +The _tracefs_instance_destroy()_ destroys the trace _instance_ and frees the
> +tracefs_instance structure.

 "The _tracefs_instance_destroy()_ frees the _instance_ structure, and will
 also remove the trace instance from the system."


> +
> +The _tracefs_instance_free()_ function frees the tracefs_instance structure,
> +without destroying the trace instance.
> +
> +The _tracefs_instance_is_new()_ function checks if the given _instance_ is newly
> +created by _tracefs_instance_create()_, or it has been in the system before that.

 "The _tracefs_instance_is_new()_ function returns true if the
 _tracefs_instance_create() that allocated _instance_ also created the
 trace instance in the system, or false if the trace instance already
 existed in the system when _instance_ was allocated by
 _tracefs_instance_create()_.

-- Steve

> +
> +RETURN VALUE
> +------------
> +The _tracefs_instance_create()_ function returns a pointer to a newly allocated
> +tracefs_instance structure. It must be freed with _tracefs_instance_destroy()_ or
> +_tracefs_instance_free()_.
> +
> +The _tracefs_instance_destroy()_ function returns -1 in case of an error,
> +or 0 otherwise.
> +
> +The _tracefs_instance_is_new()_ function returns true if the instance is
> +created by _tracefs_instance_create()_ or false if it was in the system
> +before that.
> +
> +
