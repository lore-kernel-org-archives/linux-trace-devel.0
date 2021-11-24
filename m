Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227CBC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 23:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245647AbhKXXKU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 18:10:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245432AbhKXXKU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 18:10:20 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7A1260F36;
        Wed, 24 Nov 2021 23:07:09 +0000 (UTC)
Date:   Wed, 24 Nov 2021 18:07:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2] libtraceevent: Add __rel_loc relative location
 attribute support
Message-ID: <20211124180708.599aa110@gandalf.local.home>
In-Reply-To: <163767457857.543504.6091850281066240970.stgit@devnote2>
References: <20211122223909.15f6fb50@rorschach.local.home>
        <163767457857.543504.6091850281066240970.stgit@devnote2>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 23 Nov 2021 22:36:18 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> +++ b/src/event-parse.h
> @@ -125,6 +125,7 @@ enum tep_format_flags {
>  	TEP_FIELD_IS_LONG	= 32,
>  	TEP_FIELD_IS_FLAG	= 64,
>  	TEP_FIELD_IS_SYMBOLIC	= 128,
> +	TEP_FIELD_IS_RELATIVE	= 256,
>  };
>  
>  struct tep_format_field {
> @@ -153,12 +154,12 @@ struct tep_print_arg_atom {
>  
>  struct tep_print_arg_string {
>  	char			*string;
> -	int			offset;
> +	struct tep_format_field	*field;
>  };
>  
>  struct tep_print_arg_bitmask {
>  	char			*bitmask;
> -	int			offset;
> +	struct tep_format_field	*field;
>  };
>  

We need to be careful about modifying content in event-parse.h. Because
this is exposed outside he library.

Although, I don't think this should be an issue.

We probably need to move some content out of that file if it isn't used in
any of the exposed APIs :-/

And since both libtracefs and trace-cmd do not reference any of the
tep_print_arg* fields, we probably should remove them before somebody does.

-- Steve
