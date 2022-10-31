Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC97EECAAA1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 31 Oct 2022 16:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiJaQiO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 31 Oct 2022 12:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiJaQiL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 31 Oct 2022 12:38:11 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B32B1E56;
        Mon, 31 Oct 2022 09:38:10 -0700 (PDT)
Received: from W11-BEAU-MD.localdomain (unknown [76.135.50.127])
        by linux.microsoft.com (Postfix) with ESMTPSA id 56CB4205D39E;
        Mon, 31 Oct 2022 09:38:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 56CB4205D39E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1667234290;
        bh=eoB4WIcVJxPnSUB2SBUQtuVwlD4VPrTLUjgkauX4264=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E6b6v6xjfkWF3YvhPRtC6lYkPj6z+j71JyQ0vvi+thFmm/jv9oulWMVes63NV5UWL
         aEaGd6Mvt5XZsIjIgcCIJhouU6Q1Fs1JRxTOl5cMOo1+lMNuWCs08aAYjqUS6A/f4U
         fr1HAiPuUUtELRWFu7x2iQUBdpX84G36cpdd2Xv0=
Date:   Mon, 31 Oct 2022 09:38:01 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     rostedt@goodmis.org, mhiramat@kernel.org,
        dcook@linux.microsoft.com, alanau@linux.microsoft.com,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] tracing/user_events: Use remote writes for event
 enablement
Message-ID: <20221031163749.GA69@W11-BEAU-MD.localdomain>
References: <20221027224011.2075-1-beaub@linux.microsoft.com>
 <20221027224011.2075-2-beaub@linux.microsoft.com>
 <7cad3dde-b1c5-935d-23bc-61e98c3a7b07@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cad3dde-b1c5-935d-23bc-61e98c3a7b07@efficios.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Oct 29, 2022 at 10:44:32AM -0400, Mathieu Desnoyers wrote:
> On 2022-10-27 18:40, Beau Belgrave wrote:
> 
> [...]
> > diff --git a/include/linux/user_events.h b/include/linux/user_events.h
> > index 592a3fbed98e..4c3bd16395a9 100644
> > --- a/include/linux/user_events.h
> > +++ b/include/linux/user_events.h
> > @@ -33,12 +33,16 @@ struct user_reg {
> >   	/* Input: Size of the user_reg structure being used */
> >   	__u32 size;
> > +	/* Input: Flags/common settings */
> > +	__u32 enable_bit : 5, /* Bit in enable address to use (0-31) */
> > +	      __reserved : 27;
> 
> I'm always worried about using C/C++ bitfields in uapi, because some
> compilers (e.g. MS Windows Compiler) have different implementation of the
> bitfields. See
> 
> gcc(1)
> 
> -Wnopacked-bitfield-compat
> -mms-bitfields / -mno-ms-bitfields
> 

Sure, I'll change this __u8.

> Thanks,
> 
> Mathieu
> 
> > +
> > +	/* Input: Address to update when enabled */
> > +	__u64 enable_addr;
> > +
> >   	/* Input: Pointer to string with event name, description and flags */
> >   	__u64 name_args;
> > -	/* Output: Bitwise index of the event within the status page */
> > -	__u32 status_bit;
> > -
> >   	/* Output: Index of the event to use when writing data */
> >   	__u32 write_index;
> >   } __attribute__((__packed__));
> > diff --git a/kernel/trace/trace_events_user.c
> > b/kernel/trace/trace_events_user.c--
> Mathieu Desnoyers
> EfficiOS Inc.
> https://www.efficios.com
