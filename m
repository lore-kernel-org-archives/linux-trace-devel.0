Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12790C38145
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Sep 2022 22:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiIHWRL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 18:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiIHWRK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 18:17:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D377EA63A
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 15:17:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15A81B822A4
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 22:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157FDC433D6;
        Thu,  8 Sep 2022 22:17:05 +0000 (UTC)
Date:   Thu, 8 Sep 2022 18:17:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bean Huo <beanhuo@iokpp.de>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH] libtraceevent: Documentation: Correct typo in example
Message-ID: <20220908181704.053c95a1@rorschach.local.home>
In-Reply-To: <20220823151541.151549-1-beanhuo@iokpp.de>
References: <20220823151541.151549-1-beanhuo@iokpp.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 23 Aug 2022 17:15:41 +0200
Bean Huo <beanhuo@iokpp.de> wrote:

> From: Bean Huo <beanhuo@micron.com>
> 
> There is no struct tep_event_format, it should be struct tep_event. And
> the first parameter in tep_find_event_by_record() should be tep, instead
> of pevent.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---

Applied. Thanks Bean!

-- Steve
