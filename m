Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1081C7EE24
	for <linux-trace-devel@archiver.kernel.org>; Sat,  3 Jun 2023 07:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjFCHsP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 3 Jun 2023 03:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjFCHsO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 3 Jun 2023 03:48:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2A11B6
        for <linux-trace-devel@vger.kernel.org>; Sat,  3 Jun 2023 00:48:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A39160A64
        for <linux-trace-devel@vger.kernel.org>; Sat,  3 Jun 2023 07:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEAFC433EF;
        Sat,  3 Jun 2023 07:48:08 +0000 (UTC)
Date:   Sat, 3 Jun 2023 03:47:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: Check all strdup() return values
Message-ID: <20230603034754.566d9fa6@rorschach.local.home>
In-Reply-To: <fdd6c91b-a1d2-3628-289f-b22e69f163ae@web.de>
References: <20230602230109.2b8b9265@rorschach.local.home>
        <fdd6c91b-a1d2-3628-289f-b22e69f163ae@web.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 3 Jun 2023 08:12:34 +0200
Markus Elfring <Markus.Elfring@web.de> wrote:

> …
> > +++ b/lib/trace-cmd/trace-input.c  
> …
> > @@ -5967,9 +5974,10 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
> >  	new_handle->parent = handle;
> >  	new_handle->cpustats = NULL;
> >  	new_handle->hooks = NULL;
> > -	if (handle->uname)
> > +	if (handle->uname) {
> >  		/* Ignore if fails to malloc, no biggy */
> >  		new_handle->uname = strdup(handle->uname);
> > +	}
> >  	tracecmd_ref(handle);
> >
> >  	new_handle->fd = dup(handle->fd);  
> 
> Does this return value ignorance need a bit more explanation?

Yes that should be checked.

> 
> 
> …
> > +++ b/tracecmd/trace-record.c  
> …
> > @@ -6651,6 +6658,8 @@ static void parse_record_options(int argc,
> >  		case OPT_tsoffset:
> >  			cmd_check_die(ctx, CMD_set, *(argv+1), "--ts-offset");
> >  			ctx->date2ts = strdup(optarg);
> > +			if (ctx->date2ts == NULL)
> > +				die("Faield to allocate ts-offset");
> >  			if (ctx->data_flags & DATA_FL_DATE)
> >  				die("Can not use both --date and --ts-offset");
> >  			ctx->data_flags |= DATA_FL_OFFSET;
> > @@ -6712,6 +6721,8 @@ static void parse_record_options(int argc,
> >  			    !tracecmd_compress_is_supported(optarg, NULL))
> >  				die("Compression algorithm  %s is not supported", optarg);
> >  			ctx->compression = strdup(optarg);
> > +			if (ctx->compression == NULL)
> > +				die("Faield to allocate compression algorithm");
> >  			break;
> >  		case OPT_file_ver:
> >  			if (ctx->curr_cmd != CMD_record && ctx->curr_cmd != CMD_record_agent)  
> …
> > +++ b/tracecmd/trace-split.c
> > @@ -367,6 +367,8 @@ static double parse_file(struct tracecmd_input *handle,
> >  	int fd;
> >
> >  	output = strdup(output_file);
> > +	if (output == NULL)
> > +		die("Faield to allocate output_file");
> >  	dir = dirname(output);
> >  	base = basename(output);
> >  
> …
> 
> I recommend to avoid typos also in error messages.

Heh, I'm pushing hard to get the trivial changes in so that I can start
working on some more substantial changes, and in the rush, I did make
some bad spelling mistakes. I will fix.

Thanks,

-- Steve
