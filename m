Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005C6C77B61
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Apr 2023 07:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbjDYHzs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Apr 2023 03:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjDYHzs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Apr 2023 03:55:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579F7E41;
        Tue, 25 Apr 2023 00:55:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAD9E621BE;
        Tue, 25 Apr 2023 07:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD34C433D2;
        Tue, 25 Apr 2023 07:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682409346;
        bh=I6aOxhzybe5FXeLnud3IM+zHUuO5ml+vimR2i02zYNw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kB+JXy8thtCIOtJicL3u93c2d0pmw0n9yBnRUFhPFV3NDVY/tnOCd+GdiFpCV4+rm
         9a4SpreOUx5sPfyFo1uAOuR8h+v51gKEVIH07oFfx3Zvos54U2PyfpLOLkQJhQ5doB
         rnweQWBmKWLK5Qwr8Y21gKG1sydRiNvmlMeBdC3TbAuNH9S0lKd4C32dgMYwLLw5ra
         jFfgmBiJcq3s64bFB3lCQd3HdN6UpVMZontIaoh4xMRLmHGpoxTbQC0d6xqtaH5GbR
         l7LxW4AYE8g09vwZWl20/36mpHbTB8UK3rBv5Opb7NUQY55/3W/kf+zMUAkBcP/jZx
         0QtVjJtdTyAVQ==
Message-ID: <d3e33bbb-ddee-d68c-81e9-f19a0dacd596@kernel.org>
Date:   Tue, 25 Apr 2023 09:55:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH][next][V3] rv: Fix addition on an uninitialized variable
 'run'
To:     Colin Ian King <colin.i.king@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230424094730.105313-1-colin.i.king@gmail.com>
Content-Language: en-US
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20230424094730.105313-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 4/24/23 11:47, Colin Ian King wrote:
> The variable run is not initialized however it is being accumulated
> by the return value from the call to ikm_run_monitor.  Fix this by
> initializing run to zero at the start of the function.
> 
> Fixes: 4bc4b131d44c ("rv: Add rv tool")
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>

Thanks!
-- Daniel
