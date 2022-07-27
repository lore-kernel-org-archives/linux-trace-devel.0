Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D86C04A68
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Jul 2022 19:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbiG0TOp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Jul 2022 15:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237440AbiG0TOP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Jul 2022 15:14:15 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C6445722D;
        Wed, 27 Jul 2022 12:01:33 -0700 (PDT)
Received: from kbox (unknown [76.135.27.191])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0C9AA20FE6EB;
        Wed, 27 Jul 2022 12:01:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0C9AA20FE6EB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1658948493;
        bh=Fw60Yf0VMd9Jf3E1H5eEjH/hmBkB5bsPe9qB4NufJHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hSm2H0MC4hFXtvVDIbhUQmRo+X5iR3VSGKcfxB+f2NoIVzCIWDH1z1jAgcGe0unl8
         3OJIpsNOrlLE+fW+Tp630EkfgIZUE4lyabjcvELRwg6rbkdi6mM2sCcHOaWWk0atRa
         QN8QSX51jMIen9erg8ZKBh3oO62zYf5/cvjqel1w=
Date:   Wed, 27 Jul 2022 12:01:25 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 6/7] tracing/user_events: Use bits vs bytes for
 enabled status page data
Message-ID: <20220727190125.GA1735@kbox>
References: <20220425184631.2068-1-beaub@linux.microsoft.com>
 <20220425184631.2068-7-beaub@linux.microsoft.com>
 <20220726180115.69320865@gandalf.local.home>
 <20220727000249.GA2289@kbox>
 <20220726201412.7fbd3b1f@rorschach.local.home>
 <20220727020147.GA1705@kbox>
 <20220727094517.25e9dee5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727094517.25e9dee5@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jul 27, 2022 at 09:45:17AM -0400, Steven Rostedt wrote:
> On Tue, 26 Jul 2022 19:01:47 -0700
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > Ah, I see the confusion. Sorry.  
> > 
> > EVENT_STATUS_* are internal bits that aren't used with STATUS_MASK or
> > STATUS_BYTE. It's only used to set and check the user event status byte
> > for checking if anything is attached and outputting which probe is
> > connected within the kernel side.
> > 
> > STATUS_BYTE and STATUS_MASK take a bit in a bitmap and figure out which
> > byte in the status mapping should be used and which bit in that byte
> > should be set/reset (mask) when it's enabled/disabled via a probe. Both
> > the user and kernel need to align on this logic.
> > 
> > IE: Bits above the lower 3 of the index/bit of the event to enable is the byte
> > and the lower 3 bits (& 7) is the actual bit to set.
> > 
> > For example if the user_event with the index 1024 is enabled, we need to
> > figure out which byte and bit represents that event when a probe is
> > attached.
> > 
> > I got into detail of this in the documentation for both a byte and long
> > wise checking of these values.
> > 
> > Hope that helps explain it.
> 
> Yes, but that should be in the comments above the code.
> 

Will do, I will also change to use the BIT() macro as you suggested.

> -- Steve

Thanks,
-Beau
