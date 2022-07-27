Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420B2C04A68
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Jul 2022 13:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbiG0NpY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Jul 2022 09:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiG0NpX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Jul 2022 09:45:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB110CE33;
        Wed, 27 Jul 2022 06:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41C8EB8216E;
        Wed, 27 Jul 2022 13:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32170C433C1;
        Wed, 27 Jul 2022 13:45:19 +0000 (UTC)
Date:   Wed, 27 Jul 2022 09:45:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 6/7] tracing/user_events: Use bits vs bytes for
 enabled status page data
Message-ID: <20220727094517.25e9dee5@gandalf.local.home>
In-Reply-To: <20220727020147.GA1705@kbox>
References: <20220425184631.2068-1-beaub@linux.microsoft.com>
        <20220425184631.2068-7-beaub@linux.microsoft.com>
        <20220726180115.69320865@gandalf.local.home>
        <20220727000249.GA2289@kbox>
        <20220726201412.7fbd3b1f@rorschach.local.home>
        <20220727020147.GA1705@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 26 Jul 2022 19:01:47 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> Ah, I see the confusion. Sorry.  
> 
> EVENT_STATUS_* are internal bits that aren't used with STATUS_MASK or
> STATUS_BYTE. It's only used to set and check the user event status byte
> for checking if anything is attached and outputting which probe is
> connected within the kernel side.
> 
> STATUS_BYTE and STATUS_MASK take a bit in a bitmap and figure out which
> byte in the status mapping should be used and which bit in that byte
> should be set/reset (mask) when it's enabled/disabled via a probe. Both
> the user and kernel need to align on this logic.
> 
> IE: Bits above the lower 3 of the index/bit of the event to enable is the byte
> and the lower 3 bits (& 7) is the actual bit to set.
> 
> For example if the user_event with the index 1024 is enabled, we need to
> figure out which byte and bit represents that event when a probe is
> attached.
> 
> I got into detail of this in the documentation for both a byte and long
> wise checking of these values.
> 
> Hope that helps explain it.

Yes, but that should be in the comments above the code.

-- Steve
