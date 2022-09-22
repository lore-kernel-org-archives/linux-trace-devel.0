Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAA8C6FA82
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 12:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiIVMEH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 08:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiIVMEG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 08:04:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27ADCC8D3;
        Thu, 22 Sep 2022 05:04:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78613B820DB;
        Thu, 22 Sep 2022 12:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDC3C433D6;
        Thu, 22 Sep 2022 12:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663848243;
        bh=5nk5XU9MQ5C2pdiY5cuSt5d8THL8GGQEOWHyjJzwaVo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=o8nQ9uTPS+UTCkubcZr74VLQbwFzF9CuKYe6I/O5gFBZia/gjlw+Im3Q1xXwCTIn6
         /zI6xUMwVCP1HsbB6Jea1P0FsM7/boY6THGddB8ngb9IclSD00mmGuveHHjW9jqpri
         1GUHc+wA+Qzbr6mUmPnMjjmXQPkMOPkB/7FXUh9uhVw4A9f4gYjQbFlEe2FQBdY8/I
         SfFd+Rl6EIcXKoRMLeGu6sOzkPOvK1bVpwDYp4Gq+d7vXwtLQSAYbAFKqPzNDwgPeQ
         wGQm4EFt1CPg/5tqoE+LTC+9e50hX2yxTQsBUNFLRskqIFDPWJVSQH+Qy9HkOWAw6d
         VKj67pfX8jTLA==
Message-ID: <9485756a-4315-d8f4-84b6-0615f3596daf@kernel.org>
Date:   Thu, 22 Sep 2022 14:03:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] rv/monitor: Add __init/__exit annotations to module
 init/exit funcs
Content-Language: en-US
To:     Xiu Jianfeng <xiujianfeng@huawei.com>, rostedt@goodmis.org,
        mingo@redhat.com
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220922103208.162869-1-xiujianfeng@huawei.com>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20220922103208.162869-1-xiujianfeng@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 9/22/22 12:32, Xiu Jianfeng wrote:
> Add missing __init/__exit annotations to module init/exit funcs.
> 
> Fixes: 24bce201d798 ("tools/rv: Add dot2k")
> Fixes: 8812d21219b9 ("rv/monitor: Add the wip monitor skeleton created by dot2k")
> Fixes: ccc319dcb450 ("rv/monitor: Add the wwnr monitor")
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>

Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>

-- Daniel
