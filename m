Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A78BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 15:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239956AbiBWPmn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 10:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242257AbiBWPmi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 10:42:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36352D1E5
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 07:42:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70562618A3
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 15:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C81C340E7;
        Wed, 23 Feb 2022 15:42:07 +0000 (UTC)
Date:   Wed, 23 Feb 2022 10:42:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Ian Rogers <irogers@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        John 'Warthog9' Hawley <warthog9@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sameeruddin shaik <sameeross1994@gmail.com>
Subject: Getting ready for libtracefs 1.3
Message-ID: <20220223104206.7cb5e8ce@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I'm in my final testing phase of libtracefs.

If there's anything you want added, or think should change, please let me
know soon. I may try to release it by end of (my) day today.

Thanks everyone that helped with this release!

-- Steve
