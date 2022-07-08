Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B71CCA47F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Jul 2022 19:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239914AbiGHTq1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Jul 2022 15:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238387AbiGHTq1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Jul 2022 15:46:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9ACF88F11
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Jul 2022 12:46:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AEA2627B0
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Jul 2022 19:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9E4C341C0;
        Fri,  8 Jul 2022 19:46:25 +0000 (UTC)
Date:   Fri, 8 Jul 2022 15:46:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <matteo.bertolino@huawei.com>
Cc:     <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: fixing description of a field in
 trace-cmd.dat.v7.5.txt doc
Message-ID: <20220708154623.3e09d67c@gandalf.local.home>
In-Reply-To: <20220629161845.2432-1-matteo.bertolino@huawei.com>
References: <20220629161845.2432-1-matteo.bertolino@huawei.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 29 Jun 2022 18:18:45 +0200
<matteo.bertolino@huawei.com> wrote:

> From: "Matteo Bertolino (Huawei Technologies France)" <matteo.bertolino@huawei.com>
> 
> Paragraph "Format of Section Header" states to write the size of a section on 4 bytes, but the actual size is 8 bytes (long long unsigned int).
> Submitted bug: https://bugzilla.kernel.org/show_bug.cgi?id=216185
> 
> Signed-off-by: Matteo Bertolino (Huawei Technologies France) <matteo.bertolino@huawei.com>

Applied, thanks Matteo!

-- Steve
