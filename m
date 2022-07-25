Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E7E8C43334
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Jul 2022 16:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbiGYQZ7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Jul 2022 12:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiGYQZ6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Jul 2022 12:25:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A0F1AD8A;
        Mon, 25 Jul 2022 09:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF1D86121A;
        Mon, 25 Jul 2022 16:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD63C341C6;
        Mon, 25 Jul 2022 16:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658766357;
        bh=m27zrRuz27RIjOldnMsydYQnvatN8iHP6d+tO/T1IcQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=XbxynBN2mhBEdUenQF2DyW1O5BOqMxB2nRlrPaFiFUZMjbvaD211+K7a1fANPWWLO
         QPSqyWwuI3VvINVLq3LCNCqqBz0Ngc0uo3VzAw+/p7TNCFLdpO6o1Qlo33N2WkXkcc
         nr2YYpvWZjMC6onKt5qFK5deu0afcbUvwIf+HlqlwFW8cdurbM+T37XAXWVrw31tbU
         uD41XlEnSy5eFi7k3MPUqugWN0uH0dQimVOQ9bAvyy4x4JkyUeV+3lNJfu7dT6wcYH
         7Mj9SuLpMf7ynKbhKO1zCe6GyiHftZ4ykYBYCSurbkpjJ9wwVisX/0CUMuZOEUFk/n
         bNor0on/hqmwA==
Message-ID: <b7655e0e-3835-5463-87cd-0eef995fb388@kernel.org>
Date:   Mon, 25 Jul 2022 18:25:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] rtla: Define syscall numbers for riscv
Content-Language: en-US
To:     Andreas Schwab <schwab@suse.de>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <mvmr129l0qt.fsf@suse.de>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <mvmr129l0qt.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Maybe add a single line description here?

On 7/25/22 16:34, Andreas Schwab wrote:
> Signed-off-by: Andreas Schwab <schwab@suse.de>

Note: we need to improve this, making rtla use the available headers.

I already tried but always entered a circular loop of dependencies...
it is on my to-do list, but if anyone has time, feel free to do it.

-- Daniel
