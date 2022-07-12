Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CA1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jul 2022 01:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiGLBRX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 21:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGLBRW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 21:17:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC13F33429;
        Mon, 11 Jul 2022 18:17:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ADFAB81628;
        Tue, 12 Jul 2022 01:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E771C34115;
        Tue, 12 Jul 2022 01:17:18 +0000 (UTC)
Date:   Mon, 11 Jul 2022 21:17:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     jianchunfu <jianchunfu@cmss.chinamobile.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rtla/utils: Use calloc and check the potential
 memory allocation failure
Message-ID: <20220711211716.64ef690a@gandalf.local.home>
In-Reply-To: <43855674-0f0f-bdf9-4f52-72bb4bf7e863@kernel.org>
References: <20220615073348.6891-1-jianchunfu@cmss.chinamobile.com>
        <43855674-0f0f-bdf9-4f52-72bb4bf7e863@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 8 Jul 2022 14:37:22 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> On 6/15/22 09:33, jianchunfu wrote:
> > Replace malloc with calloc and add memory allocating check
> > of mon_cpus before used.
> > 
> > Fixes: 7d0dc9576dc3 ("rtla/timerlat: Add --dma-latency option")
> > Signed-off-by: jianchunfu <jianchunfu@cmss.chinamobile.com>  
> 
> Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
> 

Applied, thanks jianchunfu and Daniel!

-- Steve
