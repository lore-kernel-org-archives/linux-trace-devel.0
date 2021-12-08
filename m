Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8FCC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Dec 2021 12:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbhLHMUq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 07:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbhLHMUl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 07:20:41 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5A4C061746
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Dec 2021 04:17:08 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id j3so3792319wrp.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 08 Dec 2021 04:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=u6b8+V9jAF42b0optbJ33fpcKJAbxLkN92sDmSGUsHk=;
        b=BiXKmR0VoJjQy6ajh7q/tLuhOWuFFIQGOOGfL30u7oEJJVcZCugsonTMYzY2y4mnaa
         44X2ex+EgeON6wdp7vUq2IYDIxUNuWRn5apwsajpOO8eEn9WwaNJRPxw4GDusSjTwxC+
         xWI0dxZKt8ylD8VjuGgkhOkEGZ8sX9E0Ka/ccNWoq2b6EyqUmRniuyw1g5d2I+N/mQdr
         GblYPYv2wXM+C344Wu5nP3KNi0oSylEwqFIki+FynTHtCPlnXKhOmrvF8Kx7D57qfds5
         39aS0WEx3MihOiNPEOc/VgoHYd87ay/lYpQ6unT4iDrk86mtjcxXGqZ5loo4Gjeybj6v
         Yr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u6b8+V9jAF42b0optbJ33fpcKJAbxLkN92sDmSGUsHk=;
        b=ibz6QH5mxoeOQmntH0hT9TSkWGftYnzRqtKzpr0VyqRF3K0GC0UXd9GIZb0/aV8mWL
         VF5eAydSyAICZPtlzCYsq1hscCW3hFwpGy7/oKL359qasUswWu/ooTe4OK0oehX9BMID
         QDaN2bBLdf8V8w7yylhCUpOTqQ4CNiI841cOhOy8LhmalzpRNRTda/qpmLUPVhtCZmof
         Xjx+2nKQ0ayYxe8femS2PO5A5eowWddATYBJeT3nlhS8UewAAfLiBs/7RFZDXq6hvNDw
         X/PymSrY8O3BT69ljRyrUYni8ew2+u1p8d9vabDYOOW1cYU9aUeLxsuMSmDJ+rDUH6iA
         AnbQ==
X-Gm-Message-State: AOAM533VfiqbVmnoGOlJ/926oXwscZanRMFFPLzMPK7VrgP5JvydrxrR
        o5bb4lRkNivV0jYn8CZVI/uQk52kRk4=
X-Google-Smtp-Source: ABdhPJxvQdOHO0mXRLtwGbtfCeYa6RsCW0KR3fKPjySB8iNePnunXhl/8AVwRRVJHcTexiLNWaJg6g==
X-Received: by 2002:adf:8bda:: with SMTP id w26mr58717568wra.440.1638965827494;
        Wed, 08 Dec 2021 04:17:07 -0800 (PST)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b11sm5493219wmj.35.2021.12.08.04.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 04:17:06 -0800 (PST)
Message-ID: <7129377c-d2aa-f801-6e47-c36ce3a10a97@gmail.com>
Date:   Wed, 8 Dec 2021 14:17:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 3/3] libtracefs: Add new API for getting synth event name
 WiP
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20211206150855.361202-1-y.karadz@gmail.com>
 <20211206150855.361202-4-y.karadz@gmail.com>
 <20211207170421.6b78bb36@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20211207170421.6b78bb36@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 8.12.21 г. 0:04 ч., Steven Rostedt wrote:
> On Mon,  6 Dec 2021 17:08:55 +0200
> "Yordan Karadzhov (VMware)"<y.karadz@gmail.com>  wrote:
> 
> I'm guessing for the lack of change log, that this is really an RFC?

This patch-set is a disaster :( Sorry about that!

The name of this patch (WiP) makes me think that I screwed up the 'git send-mail' command and somehow sent you an old 
version of the patches. Any way, a lot of the mistakes you pointed out are present also in the version that was supposed 
to be sent. I will try to do better with v2.

Thanks a lot!
Yordan
