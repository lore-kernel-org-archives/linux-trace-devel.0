Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2E6C77B7A
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jun 2023 23:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbjFGXar (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jun 2023 19:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbjFGXaq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jun 2023 19:30:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EED82680;
        Wed,  7 Jun 2023 16:30:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D1A561E85;
        Wed,  7 Jun 2023 23:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFE6C433EF;
        Wed,  7 Jun 2023 23:30:44 +0000 (UTC)
Date:   Wed, 7 Jun 2023 19:30:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>
Subject: [ANNOUNCE] libtraceevent 1.7.3 is released
Message-ID: <20230607193042.0726b1c6@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/tag/?h=libtraceevent-1.7.3

libtraceevent: 1.7.3

Changes since 1.7.2:

- Handle '%c' properly in the print fmt

- Handle "%+d" case in print fmt

- Added meson build support (but it's still not the default)

https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/

Enjoy!

-- Steve
