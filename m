Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C995C3526C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F87123BA7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgLRXdz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Dec 2020 18:33:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgLRXdz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Dec 2020 18:33:55 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34F4B23BA7;
        Fri, 18 Dec 2020 23:33:14 +0000 (UTC)
Date:   Fri, 18 Dec 2020 18:33:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 7/9] libtracefs man pages: helper APIs for working with
 trace instances.
Message-ID: <20201218183312.473a548d@oasis.local.home>
In-Reply-To: <20201217094626.1402191-8-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
        <20201217094626.1402191-8-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Dec 2020 11:46:24 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Documented APIs:
> tracefs_instance_get_name()
> tracefs_instances_walk()
> tracefs_instance_exists()
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Documentation/libtracefs-instances-utils.txt | 111 +++++++++++++++++++
>  1 file changed, 111 insertions(+)
>  create mode 100644 Documentation/libtracefs-instances-utils.txt
> 
> diff --git a/Documentation/libtracefs-instances-utils.txt b/Documentation/libtracefs-instances-utils.txt
> new file mode 100644
> index 0000000..1630d5c
> --- /dev/null
> +++ b/Documentation/libtracefs-instances-utils.txt
> @@ -0,0 +1,111 @@
> +libtracefs(3)
> +=============
> +
> +NAME
> +----
> +tracefs_instance_get_name, tracefs_instances_walk, tracefs_instance_exists -
> +Helper functions for working with tracing instances.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <tracefs.h>*
> +
> +const char pass:[*]*tracefs_instance_get_name*(struct tracefs_instance pass:[*]_instance_);
> +int *tracefs_instances_walk*(int (pass:[*]_callback_)(const char pass:[*], void pass:[*]), void pass:[*]_context)_;
> +bool *tracefs_instance_exists*(const char pass:[*]_name_);
> +
> +--
> +
> +DESCRIPTION
> +-----------
> +Helper functions for working with trace instances.
> +
> +The _tracefs_instance_get_name()_ function returns the name of the given _instance_.
> +Note that the top instance has no name, the function returns NULL for it.
> +
> +The _tracefs_instances_walk()_ function walks through all configured tracing
> +instances in the system and calls _callback_ for each one of them. The _context_
> +argument is passed to the _callback_, together with the instance name. If the
> +_callback_ returns non-zero, the iteration stops.

Does this include the top level instance? If not, this should be specified.


> +
> +The _tracefs_instance_exists()_ function checks if an instance with given _name_

   "with the given _name_"


> +exists in the system.
> +
> +RETURN VALUE
> +------------
> +The _tracefs_instance_get_name()_ returns string or NULL in case of the top


  "returns a string or "

> +instance. The returned string must _not_ be freed.
> +
> +The _tracefs_instances_walk()_ function returns 0, if all instances were iterated, 1
> +if the iteration was stopped by the _callback_, or -1 in case of an error.
> +
> +The _tracefs_instance_exists()_ returns true if an instance with given name

 "with the given name"

-- Steve

> +exists in the system or false otherwise.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <tracefs.h>
> +
> +struct tracefs_instance *inst;
> +....
> +char *name = tracefs_instance_get_name(inst);
> +
> +	if(name) {
> +		/* Got name of the instance */
> +	}
> +
> +...
> +static int instance_walk(char *name, void *context)
> +{
> +	/* Got instance with name */
> +	return 0;
> +}
> +...
> +	if (tracefs_instances_walk(instance_walk, NULL) < 0) {
> +		/* Error walking through the instances */
> +	}
> +...
> +	if (tracefs_instance_exists("foo")) {
> +		/* There is instance with name foo in the system */
> +	} else {
> +		/* There is no instance with name foo in the system */
> +	}
> +--
> +FILES
> +-----
> +[verse]
> +--
> +*tracefs.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltracefs*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtracefs(3)_,
> +_libtraceevent(3)_,
> +_trace-cmd(1)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtracefs is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
> \ No newline at end of file

