Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E30C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Dec 2021 22:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbhLGWH6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 17:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237203AbhLGWH5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 17:07:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B3EC061574
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Dec 2021 14:04:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 508EBCE1E01
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Dec 2021 22:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46237C341C1;
        Tue,  7 Dec 2021 22:04:22 +0000 (UTC)
Date:   Tue, 7 Dec 2021 17:04:21 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] libtracefs: Add new API for getting synth event
 name WiP
Message-ID: <20211207170421.6b78bb36@gandalf.local.home>
In-Reply-To: <20211206150855.361202-4-y.karadz@gmail.com>
References: <20211206150855.361202-1-y.karadz@gmail.com>
        <20211206150855.361202-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  6 Dec 2021 17:08:55 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

I'm guessing for the lack of change log, that this is really an RFC?

> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  Documentation/libtracefs-synth2.txt |  8 ++++++--
>  include/tracefs.h                   |  1 +
>  src/tracefs-hist.c                  | 11 +++++++++++
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
> index 1cb07c8..2439a54 100644
> --- a/Documentation/libtracefs-synth2.txt
> +++ b/Documentation/libtracefs-synth2.txt
> @@ -3,8 +3,9 @@ libtracefs(3)
>  
>  NAME
>  ----
> -tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd,tracefs_synth_complete,
> -tracefs_synth_get_start_hist,tracefs_synth_trace,tracefs_synth_snapshot - Creation of synthetic events
> +tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd, tracefs_synth_complete,
> +tracefs_synth_get_start_hist, tracefs_synth_trace, tracefs_synth_snapshot,
> +tracefs_synth_get_name - Creation of synthetic events
>  
>  SYNOPSIS
>  --------
> @@ -25,6 +26,7 @@ int tracefs_synth_snapshot(struct tracefs_synth pass:[*]synth,
>  int tracefs_synth_save(struct tracefs_synth pass:[*]synth,
>  		       enum tracefs_synth_handler type, const char pass:[*]var,
>  		       char pass:[**]save_fields);
> +tracefs_synth_get_name(struct tracefs_synth pass:[*]synth);

Need return value.

>  --
>  
>  DESCRIPTION
> @@ -87,6 +89,8 @@ then saven the given _save_fields_ list. The fields will be stored in the histog
>  "hist" file of the event that can be retrieved with *tracefs_event_file_read*(3).
>  _var_ changes. _var_ must be one of the _name_ elements used in *tracefs_synth_add_end_field*(3).
>  
> +*tracefs_synth_get_name*() get the name of the synthetic event.

And state that the string returned belongs to the synthetic event
descriptor and lives only as long as it does. The value returned should not
be freed.


> +
>  RETURN VALUE
>  ------------
>  Returns zero on success or -1 on error.
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 7c03086..804d738 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -505,6 +505,7 @@ enum tracefs_synth_handler {
>  	TRACEFS_SYNTH_HANDLE_CHANGE,
>  };
>  
> +const char *tracefs_synth_get_name(struct tracefs_synth *synth);
>  struct tracefs_synth *tracefs_synth_alloc(struct tep_handle *tep,
>  					  const char *name,
>  					  const char *start_system,
> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
> index 837d4e1..41c88d1 100644
> --- a/src/tracefs-hist.c
> +++ b/src/tracefs-hist.c
> @@ -736,6 +736,17 @@ struct tracefs_synth {
>  	int			arg_cnt;
>  };
>  
> + /*
> + * tracefs_synth_get_name - get the name of the synthetic event
> + * @synth: The synthetic event to get the name for
> + *
> + * Returns name string on succes or NULL on error.

And this needs to state its scope as well.

-- Steve

> + */
> +const char *tracefs_synth_get_name(struct tracefs_synth *synth)
> +{
> +	return synth ? synth->name : NULL;
> +}
> +
>  static void action_free(struct action *action)
>  {
>  	free(action->handle_field);

