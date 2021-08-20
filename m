Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CAAC4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 14:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C80161102
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 14:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbhHTOfz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 10:35:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231706AbhHTOfz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 10:35:55 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E917261102;
        Fri, 20 Aug 2021 14:35:16 +0000 (UTC)
Date:   Fri, 20 Aug 2021 10:35:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 5/5] libtraceevent: Add tep_print_selected_fields()
Message-ID: <20210820103510.6125dda1@oasis.local.home>
In-Reply-To: <a15c7f5f-aa16-7e34-f2fe-bf05a13069e5@gmail.com>
References: <20210812085929.54832-1-y.karadz@gmail.com>
        <20210812085929.54832-6-y.karadz@gmail.com>
        <20210819125510.0b0b04c2@oasis.local.home>
        <a15c7f5f-aa16-7e34-f2fe-bf05a13069e5@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 20 Aug 2021 16:36:12 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:
		if (field_mask & ignore_mask)
> >> +			continue;
> >> +
> >>   		trace_seq_printf(s, " %s=", field->name);
> >>   		_tep_print_field(s, data, field, &parse);
> >> -		field = field->next;
> >>   	}
> >>   }
> >>   
> >> +void tep_print_selected_fields(struct trace_seq *s, void *data,  
> > 
> > As the above is an API, it needs a kernel doc type comment, and also an
> > addition to the man pages. The man page may be a separate patch.
> >   
> 
> I was thinking of maybe changing the second argument of the function to
> 
> void tep_print_selected_fields(struct trace_seq *s,
> 			       struct tep_record *record,
> 			       struct tep_event *event,
> 			       unsigned long long ignore_mask)
> 
> 
> > -- Steve
> > 
> >   
> >> +			       struct tep_event *event,
> >> +			       unsigned long long ignore_mask)
> >> +{
> >> +	print_selected_fields(s, data, event, ignore_mask);  
> 
> respectively here we will have
> 
> 	print_selected_fields(s, record->data, event, ignore_mask);
> >> +}  
> 
> This way the call will look cleaner.
> 
> 	tep_print_selected_fields(s, record, event, mask);
> 
> instead of
> 
> 	tep_print_selected_fields(s, record->data, event, mask);
> 
> But on the other hand, this will make the new API inconsistent with the existing
> "tep_print_fields()" API bellow.

I think we rushed the libtraceevent APIs :-(

There's a lot of them I hate, and I agree, passing record would have made more sense.

I've been thinking of reworking a lot of them, but we need to add new APIs.

tep_print_record_fields()
tep_print_record_selected_fields()

??

-- Steve
