Return-Path: <SRS0=Ta82=TI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6574BC04A6B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 May 2019 16:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41AAE206A3
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 May 2019 16:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfEHQWV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 May 2019 12:22:21 -0400
Received: from ms.lwn.net ([45.79.88.28]:53550 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727280AbfEHQWU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 May 2019 12:22:20 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 02D482C5;
        Wed,  8 May 2019 16:22:19 +0000 (UTC)
Date:   Wed, 8 May 2019 10:22:19 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tom Zanussi <zanussi@kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Documentation/trace: Add clarification how histogram
 onmatch works
Message-ID: <20190508102219.30f8c625@lwn.net>
In-Reply-To: <20190508121854.2bf6340b@gandalf.local.home>
References: <20190507144946.7998-1-tstoyanov@vmware.com>
        <20190507201157.2673f2de@gandalf.local.home>
        <1557321326.2167.5.camel@kernel.org>
        <20190508121854.2bf6340b@gandalf.local.home>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 8 May 2019 12:18:54 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Jon,
> 
> Can you take this patch in your tree?

Will do.

jon
