Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C0D3C7EE22
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 May 2023 18:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238870AbjEKSJY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 May 2023 14:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238953AbjEKSJW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 May 2023 14:09:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBE97DAA;
        Thu, 11 May 2023 11:09:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38F5160B00;
        Thu, 11 May 2023 18:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C66C433D2;
        Thu, 11 May 2023 18:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683828541;
        bh=aAoCJG5fBPBQHqqcyNy+cvL5bUN9yjIgu2mpTIMhZc0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JiMAALBYW5cYh1IFDpSTbByaGn1ozIUZWPS1DS8L8ovbXk+Lz13i8s0fany9nGYyO
         ro8L343/5v/hIVZRdMIYdT4ik4S0iO2cWgczLvnVyr/VtLbJ1u/Q4+pw/ksg3UqvIO
         ZNu9RGqFIBuXDrPrFX3furaxpHE4j4sy5Wwc+xLnbh4/8caZdf9FlOElkCzivwI7Jg
         NWku51O4xCyyWVNwXcWn8u0XMjNy0sI5Nu7qVmDyFiGjZTLKW0Ej86+vPqGD5/Cncs
         x71ZIGvGAsemw2PuG0UujI1QSzSYiOqub07vxnGDch9yi3NM3GUaNu7QMEcHNDku0Y
         xkQFeC4mEYBhw==
Message-ID: <8ac29644-8f84-45d1-f9c5-1e8a93fc71d7@kernel.org>
Date:   Thu, 11 May 2023 20:08:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: 0001-rtla-Add-C-cgroup-support.patch
Content-Language: en-US
To:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Juri Lelli <juri.lelli@redhat.com>,
        William White <chwhite@redhat.com>
References: <cover.1683827510.git.bristot@kernel.org>
 <20230511180457.7623-1-bristot@kernel.org>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20230511180457.7623-1-bristot@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

ok, today is one of those days... Ignore this email, it is the log --dry-run I tried before.

I need to automate this final checks :-)

-- Daniel
