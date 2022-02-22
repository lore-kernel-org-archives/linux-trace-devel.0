Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FE2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 16:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbiBVRAT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 12:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiBVRAS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 12:00:18 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 55EC716C4E1
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 08:59:53 -0800 (PST)
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id E540620C28FE;
        Tue, 22 Feb 2022 08:59:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E540620C28FE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1645549193;
        bh=RlWf0qFMADA1XIAmMYDAMYlOEO9DZ5X2blFVoP+FZ2g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c9qDEXsVdlvwl8/Y1Zlij3TChV4lCg3Lt6FLV7hqqlbtIKZHB6zdpFhu7DwJNjzSw
         8frJmbqMC9YNGMWsEVyR9uwN9A1J7nSy2MGHoZ8U9Gm9O4aAw/aWmBFf/fL5N0PTp6
         PbXD6QMgxbGv7w2y0wlaiA8/H2Y0drbFBWA4gvBM=
Date:   Tue, 22 Feb 2022 08:59:46 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs sources
Message-ID: <20220222165946.GA1709@kbox>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
 <20220218225058.12701-2-beaub@linux.microsoft.com>
 <dba49d0e-cac5-5945-e02e-b45a6d751032@gmail.com>
 <20220221175720.GA1738@kbox>
 <20220221141625.60a7db50@rorschach.local.home>
 <c2b27dce-96fb-176e-51b9-df6f1ce760fa@gmail.com>
 <20220222090021.3f2ba377@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222090021.3f2ba377@rorschach.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Feb 22, 2022 at 09:00:21AM -0500, Steven Rostedt wrote:
> On Tue, 22 Feb 2022 08:27:31 +0200
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
> > I have one last question. Do you consider as a valid use case that
> > the library must support, someone to do a just 'test" without writing
> > after this, or to "write" without testing first?
> 
> Actually, that's a very good point.
> 
> I was thinking that I didn't like the "test" name, and was thinking of
> having it be:
> 
> 	if (tracefs_user_event_enabled(event)) {
> 		tracefs_user_event_record(event, ...);
> 	}

I do like the renaming of test to enabled and write to record.

> 
> But I think you have a good point. Perhaps we should just have:
> 
> 	tracefs_user_event_trace(event, ...);
> 
> and it do all the work. But it would need to be a macro, that does:
> 
> #define tracefs_user_event_trace(event, ...)			\
> 	do {							\
> 		if (tracefs_user_event_enabled(event)) {	\
> 			tracefs_user_event_record(event, ##__VA_ARGS); \
> 		}						\
> 	} while (0)
> 
> Because we do not want to have the compiler process the arguments when
> the event is not enabled. That would be too much overhead.
> 
> But as a macro, it would work.
> 
> Thoughts?

Many times we have found that we have to do work that should only be
performed if the event is enabled. As long as there is a still clear
ways to check without the macro, this would be fine with me.

IE: strlen(message)

We should not walk strings unless the event is enabled.

Thanks,
-Beau
