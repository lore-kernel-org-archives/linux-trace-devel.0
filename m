Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C1BC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 03:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F026B61104
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 03:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhHSD5d (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235806AbhHSD5c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 23:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32669610A1;
        Thu, 19 Aug 2021 03:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629345416;
        bh=IveqeSrPUIZynVJd2mOct5LT4I14q7nCwELTGyT+3sk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KP7C/5nnVg2Ac+OArzTlIBiT8n4pi+6pWo4kr+jSPFY/yTXlA+1CFWQvOyJwrOGyI
         xNYfaJd+4eFhGUelhmgKG0XoF4ijoYTsz7ZAmS4Zd/2hr3oiG2VuPKh+KoZ3XbGmkG
         rQJv/21+12td0JgQwUT03tD5m7A0+FQx4KVHr1evTMRQSIJMGKXrJqLknWToyD/7UX
         nHTrr0y6GlCojOu++O9+KG2AiZ2SgMnKuk4CEbz4zzOtuQJg1dwhpeghUXb6EksVdp
         gJfjjZIoEu6uRhIwhQBf/z7qgJyef6M9vgvyk+rGjXmUwMSKXLwpRJwtwCPz3jvoGA
         VjN5lbD6JQoHw==
Date:   Thu, 19 Aug 2021 12:56:52 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 7/7] tracing: Add a probe that attaches to trace
 events
Message-Id: <20210819125652.bb6b980cf0ef04e0158bc564@kernel.org>
In-Reply-To: <20210818233757.686cd7c8@oasis.local.home>
References: <20210817034255.421910614@goodmis.org>
        <20210817035028.190000494@goodmis.org>
        <20210819112920.a2fbfdc812967c2743953fd0@kernel.org>
        <20210818233757.686cd7c8@oasis.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 18 Aug 2021 23:37:57 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:


> > Here, you don't check the event name collision. Since the kprobe event
> > supports multiprobe event, it checks the collision by itself.
> > See register_trace_kprobe().
> > BTW, I found another issue on the name collision. Let me fix it.
> 
> I'm thinking of adding this above before taking the event_mutex:
> 
> 	/* Check if the name already exists */
> 	if (find_event_probe(group, event))
> 		return -EEXIST;
> 
> Where I have:
> 
> static bool find_event_probe(const char *group, const char *event)
> {
> 	struct dyn_event *ev;
> 	struct trace_eprobe *ep;
> 
> 	for_each_dyn_event(ev) {
> 		if (ev->ops != &eprobe_dyn_event_ops)
> 			continue;
> 		
> 		ep = to_trace_eprobe(ev);
> 		if (strcmp(ep->tp.event->class.system, group) == 0 &&
> 		    strcmp(ep->tp.event->call.name, event) == 0)
> 			return true;
> 	}
> 	return false;
> }

Yeah, but I think this should be done with event_mutex, shouldn't it?

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
