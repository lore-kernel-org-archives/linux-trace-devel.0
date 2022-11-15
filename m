Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75E1C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 21:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbiKOVJZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 16:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiKOVJY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 16:09:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E390A1C136
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 13:09:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8281B61A08
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 21:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58002C433C1;
        Tue, 15 Nov 2022 21:09:22 +0000 (UTC)
Date:   Tue, 15 Nov 2022 16:10:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: Re: [PATCH 1/2] libtraceevent: Add boiler-plate code for cpumask
 types
Message-ID: <20221115161005.74f62903@gandalf.local.home>
In-Reply-To: <xhsmhedu9zc3g.mognet@vschneid.remote.csb>
References: <20221018151630.1513535-1-vschneid@redhat.com>
        <20221018151630.1513535-2-vschneid@redhat.com>
        <20221109190634.1fd9200d@rorschach.local.home>
        <xhsmhedu9zc3g.mognet@vschneid.remote.csb>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 11 Nov 2022 16:32:03 +0000
Valentin Schneider <vschneid@redhat.com> wrote:

> On 09/11/22 19:06, Steven Rostedt wrote:
> > On Tue, 18 Oct 2022 16:16:29 +0100
> > Valentin Schneider <vschneid@redhat.com> wrote:
> >  
> >> @@ -3484,6 +3498,11 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
> >>              free_token(token);
> >>              return process_bitmask(event, arg, tok);
> >>      }
> >> +	if (strcmp(token, "__get_cpumask") == 0 ||
> >> +	    strcmp(token, "__get_cpumask") == 0) {  
> >
> > Hmm, not sure what the difference between the above two are.
> >  
> 
> One makes sense, the other doesn't :-)
> 
> That's a copy/paste fail, the second one wants to be "__get_rel_cpumask"

I was expecting a v2, should I wait?

-- Steve
