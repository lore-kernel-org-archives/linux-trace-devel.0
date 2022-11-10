Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BCEC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 01:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbiKJBMI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 20:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiKJBMH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 20:12:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C363922507
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 17:12:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80E3FB81F37
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 01:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1C2C433C1;
        Thu, 10 Nov 2022 01:12:04 +0000 (UTC)
Date:   Wed, 9 Nov 2022 20:12:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Bergin <peter@berginkonsult.se>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] libtracefs: make it possible to set
 libdir,includedir and mandir from outside
Message-ID: <20221109201201.102962f9@rorschach.local.home>
In-Reply-To: <20221101111143.191772-1-peter@berginkonsult.se>
References: <20221101111143.191772-1-peter@berginkonsult.se>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  1 Nov 2022 12:11:43 +0100
Peter Bergin <peter@berginkonsult.se> wrote:

> When building in build frameworks such as openembedded it is desired
> to use the defintion of directories from the build framework.
> 
> Signed-off-by: Peter Bergin <peter@berginkonsult.se>

Applied. Thanks Peter!

-- Steve
