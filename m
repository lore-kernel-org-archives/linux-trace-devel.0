Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725E3C07E95
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CB2D6199E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhGGNQQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 09:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhGGNQP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 09:16:15 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91CBF61A24;
        Wed,  7 Jul 2021 13:13:34 +0000 (UTC)
Date:   Wed, 7 Jul 2021 09:13:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [PATCH 4/4] libtracefs: Implement API to create / modify and
 display histograms
Message-ID: <20210707091327.138fe95f@oasis.local.home>
In-Reply-To: <0707117e-119a-c7b6-ee1e-ef57e49917ad@gmail.com>
References: <20210707031110.249759-1-rostedt@goodmis.org>
        <20210707031110.249759-5-rostedt@goodmis.org>
        <0707117e-119a-c7b6-ee1e-ef57e49917ad@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 7 Jul 2021 11:12:03 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Hi Steven,

> > +
> > +	switch (cmd) {
> > +	case START:
> > +		ret = tracefs_hist_start(hist);
> > +		if (ret) {
> > +			char *err = tracefs_error_last(instance);
> > +			if (err)
> > +				fprintf(stderr, "\n%s\n", err);
> > +		}
> > +		break;
> > +	case PAUSE:
> > +		ret = tracefs_hist_pause(hist);
> > +		break;
> > +	case CONT:
> > +		ret = tracefs_hist_continue(hist);
> > +		break;
> > +	case RESET:
> > +		ret = tracefs_hist_reset(hist);
> > +		break;
> > +	case DELETE:
> > +		ret = tracefs_hist_destroy(hist);
> > +		break;
> > +	case SHOW: {
> > +		char *content;
> > +		content = tracefs_event_file_read(instance, "kmem", "kmalloc",
> > +						  "hist", NULL);  
> 
> It looks more intuitive to have
> 
> char *tracefs_hist_read(struct tracefs_hist *hist)

I thought a little about this, and rather have parsing of the file. We
could always add a helper function to do this later if it is helpful,

> 
> > +		ret = content ? 0 : -1;
> > +		if (content) {
> > +			printf("%s\n", content);
> > +			free(content);
> > +		}
> > +		break;
> > +	}
> > +	}  
> 
> This "switch" can move to the library as well.
> We can have a method
> 
> int tracefs_hist_ctrl(struct tracefs_hist *hist,
> 		      const char *cmd,
> 		      void *output);
> 

Both this and the read file above could be added as enhancements, but I
don't think we need to add them to this current patch.

Thanks,

-- Steve
