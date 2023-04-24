Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F86CC7618E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Apr 2023 09:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjDXJ1G (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Apr 2023 05:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDXJ1G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Apr 2023 05:27:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F33C1B9;
        Mon, 24 Apr 2023 02:27:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16AD96114F;
        Mon, 24 Apr 2023 09:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC975C433EF;
        Mon, 24 Apr 2023 09:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682328424;
        bh=k5EFLxdU43Ba/q4bjpnDrDSYlmS54Dz/QG0RYl+piag=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=K+AImau6XqqRSzDj6tj8YXT+3GQh0XEasJmRinq2+XQR2pHJfT86oeggxAWl9DAFk
         L9Qy84swN9NSpNprPRcUcg2EdJgbJRADPCaqVuP6rsSzQcIN6Kiuqn0zUwB/3VoaMi
         ell6I+QRjVbWgXN3dCAbGkJFQ9sP5WXfvOnrgJzgY5LvQWkO3OeqYEBL7Tik7pZia3
         csoc151V/u6olUIWTcgROrdEkiIdLL4LHBo+ySagt2Y49FkzId94WjOtn7hB4XXvPd
         GqPkNkSu/Q849CSaeXL848juykYbQBrToSHvcqQxzk7QeEtsM0wrvIj4QrYdoqoYiF
         UIETgdS6oTVBg==
Message-ID: <20f29b0b-b742-a3b6-921c-6946a9d7155a@kernel.org>
Date:   Mon, 24 Apr 2023 11:27:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] tools/tracing/rtla: Add .gitignore
Content-Language: en-US
To:     Rong Tao <rtoax@foxmail.com>
Cc:     rongtao@cestc.cn, Steven Rostedt <rostedt@goodmis.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:Real-time Linux Analysis (RTLA) tools" 
        <linux-trace-devel@vger.kernel.org>
References: <tencent_8042C05909979D2A1AAFA8A3028854065808@qq.com>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <tencent_8042C05909979D2A1AAFA8A3028854065808@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 4/21/23 14:12, Rong Tao wrote:
> From: Rong Tao <rongtao@cestc.cn>

The patch makes sense (perf also has one), but we can improve the log.

Change the subsystem in the subject to rtla only, i.e.,

rtla: Add .gitignore file

> Ignore rtla binary.

Improve the log:

Add .gitignore file to ignore the rtla binary.
 
> Signed-off-by: Rong Tao <rongtao@cestc.cn>

Mind sending a v2?

Thanks
-- Daniel
