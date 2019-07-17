Return-Path: <SRS0=BCkm=VO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E99C76186
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 13:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63EEE208C0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 13:38:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dFpjac/t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfGQNiw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 09:38:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38332 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfGQNiw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 09:38:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so839655wmj.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2019 06:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kOYT9HSpAe8tco+Poo7MgXVmx8S4wOmET++9Q/eA2lM=;
        b=dFpjac/tOtNPN9JfN1xmbOo6wNrevwrfTJJpnEDRN3kagXigsaT/b6/+LONArVrECk
         nXpvNMk0Q+9NQby4+ibGczWVabMR7P6Y1sEwDPexTodSI1XrmpcA5UzmsEodY1yop6Za
         Mf3saLlrPfp3OR1sLLTGy7sTn45RimDi0PFLNkKClfBRHoQxRuGYqHq6GikSWMt5rexP
         TCg8ABySPF2tQCtzZMw1Hebpba/3Zz0uIwlu4fL5decPQtaeGo6V/+1egfnVQi2X2n86
         M0k+lLpOztoYHUQNbr+1N6j5iCMhBgscnHwBx7fx/rdAdaV9xdIyqFYJkiOyUarOrzYv
         E3zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kOYT9HSpAe8tco+Poo7MgXVmx8S4wOmET++9Q/eA2lM=;
        b=QDldTqjLvHnj7HEsxsYBZr1EZyoRP16l21d0DH3yPDgyBL0aITqonf3uSGoS4+/i4w
         u43+5cDiOSjseY6udXuemQkTCY7+8T1GTNpiW8gzoYm6oB0F19e1d9kpshbMYDTgiXg8
         IRijYbr3/YWoujkvTDl8l8DuCLB/q7aQRnEp9iEa/lfqyO+xapMLg0V4Q3Htt2DofyN+
         cKmP1lR+JUfjdNkJcRhAFTxZKDcFtDPy4orzMJn9CCjfRrDer7zYQZ6zbknFTEGKh3Ow
         Q74tp0zY2IbvOCcDkmzSdYmkPotmRoiCWdo+AAtD0Vz21uw1jQ7W8vNAi4J8ZgVnElw1
         B5eg==
X-Gm-Message-State: APjAAAVsyFIucDCtnjhHD6N4AXy0w8P+0Jpgv+ReSiR+XoKuxmzJgTzl
        e0CbTzpBqQCdfYxdt6X+q8E8PA+W7LQ=
X-Google-Smtp-Source: APXvYqwTs0AyXzWOrKU+cUKqfM8EL609STj4Jr6onrRzjA0ZrmTmq74AMKyScwDXpez7tVZiPbvb6w==
X-Received: by 2002:a1c:7d08:: with SMTP id y8mr15002899wmc.50.1563370729831;
        Wed, 17 Jul 2019 06:38:49 -0700 (PDT)
Received: from [10.27.112.183] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u2sm22891383wmc.3.2019.07.17.06.38.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 06:38:49 -0700 (PDT)
Subject: Re: [PATCH 1/2] kernel-shark: Initialize the data-related fields of
 the model
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20190717085306.12393-1-y.karadz@gmail.com>
 <20190717085306.12393-2-y.karadz@gmail.com>
 <20190717083709.4a56867c@gandalf.local.home>
 <3117115a-5468-1b26-9a89-d871f43a1289@gmail.com>
 <20190717092818.34329697@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <00e8b2e5-2112-0681-7cbb-a3919ddd63c8@gmail.com>
Date:   Wed, 17 Jul 2019 16:38:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190717092818.34329697@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 17.07.19 г. 16:28 ч., Steven Rostedt wrote:
> On Wed, 17 Jul 2019 15:42:31 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>>> Are we just trying to set all fields of histo to NULL or zero? If so,
>>> why not just do:
>>>
>>> 	memset(histo, 0, sizeof(*histo));
>>>
>>> ?
>>>
>>> This will make sure ksmodel_init() zeros all of histo when/if we add new
>>> fields.
>>>    
>>
>> Yes, this will do a better job.
> 
> Care to send a v2 patch?

Just make the change and apply, if this is OK with you.

Thanks a lot!
Yordan

> 
> Thanks Yordan!
> 
> -- Steve
> 
