Return-Path: <SRS0=9eMf=2K=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3757AC43603
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Dec 2019 15:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 083B021D7E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Dec 2019 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576855513;
	bh=I120XmNCPkceBpwM+20DLte7ZvmMd1dBGeem+XYZrB8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=bmk1/YRseXNeB//LtUckI4AjRJ2mhrYH/WMeX4JgkECk9Dg6/z0ImkUm4nQgsrawK
	 /hdeJ+d8vBxSZZzlK/fUwxhmqzefWAaulVRqUn+xR3/CEVxAB1oOsOVyjxbQDgIXXJ
	 Urrz1AXtWfcPIXrM0i8/CsWfbYgGYcQzzTYZC420=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfLTPZM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 10:25:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbfLTPZM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 10:25:12 -0500
Received: from tzanussi-mobl (c-98-220-238-81.hsd1.il.comcast.net [98.220.238.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 854172146E;
        Fri, 20 Dec 2019 15:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576855512;
        bh=I120XmNCPkceBpwM+20DLte7ZvmMd1dBGeem+XYZrB8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OafEgr63ZgTxe/dai57nR/IZ+vapwN463e2x9pbXYdAVTb+CVC/dQVRyfe09txOFF
         fWCGf59iliG1BvOVe0C2ng6exP4/XYVe2q8Xy6w7ed2sBQIxdBm1xCUKgY6IVcCM5F
         N+3Os5H/HCnUJMps3Lzyh1vQpuwFto/861uBGVBM=
Message-ID: <1576855510.4838.1.camel@kernel.org>
Subject: Re: [PATCH 3/3] ftrace: fix endianness bug in histogram trigger
From:   Tom Zanussi <zanussi@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Sven Schnelle <svens@linux.ibm.com>
Cc:     linux-trace-devel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date:   Fri, 20 Dec 2019 09:25:10 -0600
In-Reply-To: <20191219183349.1f088b55@gandalf.local.home>
References: <20191218074427.96184-1-svens@linux.ibm.com>
         <20191218074427.96184-4-svens@linux.ibm.com>
         <20191219183349.1f088b55@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

On Thu, 2019-12-19 at 18:33 -0500, Steven Rostedt wrote:
> On Wed, 18 Dec 2019 08:44:27 +0100
> Sven Schnelle <svens@linux.ibm.com> wrote:
> 
> > At least on PA-RISC and s390 synthetic histogram triggers are
> > failing
> > selftests because trace_event_raw_event_synth() always writes a 64
> > bit
> > values, but the reader expects a field->size sized value. On little
> > endian
> > machines this doesn't hurt, but on big endian this makes the reader
> > always
> > read zero values.
> 
> Tom,
> 
> Does this patch look fine to you?

Yeah, it looks fine to me.

Acked-by: Tom Zanussi <tom.zanussi@linux.intel.com>

> 
> Also, it was only sent to linux-trace-devel. You can see the original
> patch here:
> 
>   https://lore.kernel.org/linux-trace-devel/20191218074427.96184-4-sv
> ens@linux.ibm.com/
> 
> -- Steve
> 
> 
> > 
> > Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
> > ---
> >  kernel/trace/trace_events_hist.c | 21 ++++++++++++++++++++-
> >  1 file changed, 20 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/trace/trace_events_hist.c
> > b/kernel/trace/trace_events_hist.c
> > index f49d1a36d3ae..f62de5f43e79 100644
> > --- a/kernel/trace/trace_events_hist.c
> > +++ b/kernel/trace/trace_events_hist.c
> > @@ -911,7 +911,26 @@ static notrace void
> > trace_event_raw_event_synth(void *__data,
> >  			strscpy(str_field, str_val,
> > STR_VAR_LEN_MAX);
> >  			n_u64 += STR_VAR_LEN_MAX / sizeof(u64);
> >  		} else {
> > -			entry->fields[n_u64] =
> > var_ref_vals[var_ref_idx + i];
> > +			struct synth_field *field = event-
> > >fields[i];
> > +			u64 val = var_ref_vals[var_ref_idx + i];
> > +
> > +			switch (field->size) {
> > +			case 1:
> > +				*(u8 *)&entry->fields[n_u64] =
> > (u8)val;
> > +				break;
> > +
> > +			case 2:
> > +				*(u16 *)&entry->fields[n_u64] =
> > (u16)val;
> > +				break;
> > +
> > +			case 4:
> > +				*(u32 *)&entry->fields[n_u64] =
> > (u32)val;
> > +				break;
> > +
> > +			default:
> > +				entry->fields[n_u64] = val;
> > +				break;
> > +			}
> >  			n_u64++;
> >  		}
> >  	}
> 
> 
