Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 073ADC43219
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Nov 2021 15:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245418AbhK3PHW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 10:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244269AbhK3PAz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 10:00:55 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABA7C08E8AE
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Nov 2021 06:53:02 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x6so87512845edr.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Nov 2021 06:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=x4GXIxEHjHViEsk7/HKda+HPNguWNtq1Ab7x0cPdhgg=;
        b=S/4B51DX0HKT2yVKCl0p4IJvYsQhVssmwcLWLSzSIG2HzTYtdkiGunKKHKiy0NKFrR
         YvAUfvuJmWBSxdYp+3j1Rymf26FGFp58P8uNgw1P6+OAyLx/jOexHzqkJmQ1tYU1desD
         85w6Rius5SH8DoNLYfYu7O0gaHbU7eGaO/vjaY6huHo6Wl/obS0bbIupsdT0+ZyvfyAn
         wuVnhGchVdIKaAL7zefbgB++hIeETTZrLPTfDvzSDd6x7+HSHlMKLqfxu+UzdZu5MhD7
         c5APRBkytFKnanp5FK0xpN3OQl8DqhXvZlOCkt/J/qTMDdJz9Gt+hFgiaZ9TMoUyAJZV
         MZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x4GXIxEHjHViEsk7/HKda+HPNguWNtq1Ab7x0cPdhgg=;
        b=uQtjzhBADGBwfWXdtCWtVZzbLgUWg6DHbUdOFbpFdn2m3Cxs8m5DzF8IB9ph2umokx
         PZmRmgFlCtC4Ta6VUq4gA2IzGVrVi4C6nVmNunZYNINbFDOPmznZ5uZ81bkOsqe1wc/1
         tGRZs2O5Vgqim1Ir6XjZwGyRJtWs+y307S2wXunlj8+pr53MQUw3sy4fappGT2fo1bdJ
         5MNC7Y01oNxon14H6epRRy9TpEZv/7U5eIETxNmNXZk+DQ184V7tOeITXpNkgsH4NvGO
         ShQ0PpJD+Mn6ZOIDaZYPs4fxkB6TQUynUn6T2kPjVqOtXvGrXWt9kVCRwWc+24TqG3SN
         WUPA==
X-Gm-Message-State: AOAM530uL9wLYGYFRY4SHdOyBGOG3SeuY/1BOBXElEcvsF3d9DVq+HOj
        9JoWP3+o2SdfchY5yyNlt6m43V+IJZA=
X-Google-Smtp-Source: ABdhPJzTcJopj9HJoQNCI3FrUtlYwaw9IurEkJu93gdVXqWYmafcC3PpEPZujro14Cbj5+7GVvpMtw==
X-Received: by 2002:a17:907:d08:: with SMTP id gn8mr65926238ejc.395.1638283980883;
        Tue, 30 Nov 2021 06:53:00 -0800 (PST)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b11sm12580609ede.62.2021.11.30.06.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 06:53:00 -0800 (PST)
Message-ID: <7d155abd-c0ee-786f-e670-16ff57aa02b5@gmail.com>
Date:   Tue, 30 Nov 2021 16:52:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 0/1] libtracefs: New API for clearing filters
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20211130143422.127433-1-y.karadz@gmail.com>
 <20211130095056.2645be28@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20211130095056.2645be28@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 30.11.21 г. 16:50 ч., Steven Rostedt wrote:
> On Tue, 30 Nov 2021 16:34:21 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> This patch applys on tom of the 'New tracefs APIs' patch-set.
> 
> Please post a link to the patches that this series applies on top of.
> Subject names are not precise (harder to find).
> 

Here is the link:
https://patchwork.kernel.org/project/linux-trace-devel/list/?series=587537

thanks!
Y.

> -- Steve
> 
