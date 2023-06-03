Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B6DC77B7A
	for <linux-trace-devel@archiver.kernel.org>; Sat,  3 Jun 2023 16:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjFCQOw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 3 Jun 2023 12:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjFCQOv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 3 Jun 2023 12:14:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840A8A2
        for <linux-trace-devel@vger.kernel.org>; Sat,  3 Jun 2023 09:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1818960B61
        for <linux-trace-devel@vger.kernel.org>; Sat,  3 Jun 2023 16:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A422C433EF;
        Sat,  3 Jun 2023 16:14:43 +0000 (UTC)
Date:   Sat, 3 Jun 2023 12:14:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-trace-devel@vger.kernel.org, cocci@inria.fr
Subject: Re: [PATCH v3] trace-cmd: Check all strdup() return values
Message-ID: <20230603121400.0706000f@rorschach.local.home>
In-Reply-To: <8b23bb42-0b20-850f-b155-c407b671fdda@web.de>
References: <20230603054450.1e83841a@rorschach.local.home>
        <8b23bb42-0b20-850f-b155-c407b671fdda@web.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 3 Jun 2023 13:20:37 +0200
Markus Elfring <Markus.Elfring@web.de> wrote:


> …
> > +++ b/lib/trace-cmd/trace-output.c
> > @@ -230,6 +230,7 @@ void tracecmd_set_out_clock(struct tracecmd_output *handle, const char *clock)
> >  	if (handle && clock) {
> >  		free(handle->trace_clock);
> >  		handle->trace_clock = strdup(clock);
> > +		/* TODO: report error if failed to allocate */
> >  	}
> >  }  
> 
> How will this place be improved?

Bah. This patch is not worth the pain. I'm just going to drop it.

-- Steve
