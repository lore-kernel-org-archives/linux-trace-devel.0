Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CAAC77B76
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Apr 2023 12:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDMMUu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Apr 2023 08:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjDMMU1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Apr 2023 08:20:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B225FFC
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Apr 2023 05:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 455B660F90
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Apr 2023 12:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4958FC433D2;
        Thu, 13 Apr 2023 12:20:25 +0000 (UTC)
Date:   Thu, 13 Apr 2023 08:20:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/3] Introduce new API to reset ftrace instance
Message-ID: <20230413082023.0bec6b82@gandalf.local.home>
In-Reply-To: <CAPpZLN7E4hFL-a1Eg5Gc3=fpyyPW8S+Gp+xrmD48hqnK2YCsoA@mail.gmail.com>
References: <20230328150308.34783-1-tz.stoyanov@gmail.com>
        <20230328111331.1e9cb292@gandalf.local.home>
        <CAPpZLN7E4hFL-a1Eg5Gc3=fpyyPW8S+Gp+xrmD48hqnK2YCsoA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 13 Apr 2023 15:17:11 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> ping
> Did you have time to take a look at these patches? I'm planing to use
> the library in a new project and need this new functionality.

No, I haven't had a chance. I've been focusing on kernel scheduler changes.
But I'll try to carve out time for this as well, as I will need this
functionality too.

-- Steve
