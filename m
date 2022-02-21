Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B24C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 12:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358002AbiBUMcY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 07:32:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357974AbiBUMcW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 07:32:22 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DC413CDD
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 04:31:59 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id a8so32932767ejc.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 04:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sHqnj5NnDcDVcHPPMwbWU8RA/0JI+M48/1qX0HTkhdk=;
        b=p/UB1MsV7HWoQnHaJdFhNLghx2vTTVaBhnfgBP7Qi610Ei+Nwzhpl/pzc0ufIguaok
         yumIVPV0jn1qHOO3gCuCRAqgRrPROfnkVCs/0puRSBfARzTsSK9K4oO4YmKivkmD/GV2
         +3qHFJYAZafbQduu40HsCqySuYvl/KOotjAl00fJxTBcQQ37HkUYwMfiY6N13yBkYJq1
         etEDReZ6hMNh0fOmyEYZyp6xDb1kSuyhqmlMN5uN7xpjt5ue3bmtoYYH3nmQKH/sNxPz
         G+7pLv6JMzgx2vAsYSDNtbtEXKpQTl/a5NGj/8CBx9Kjlt7YCPi/IHl1jkjB8ef7JnuJ
         cRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sHqnj5NnDcDVcHPPMwbWU8RA/0JI+M48/1qX0HTkhdk=;
        b=FrMOFEnQcKj5z5/DlDBiWcEYzQ36XlmCi0xO8L0YiCqw5XZ27g4iSSIUSVPkTJc95l
         pWwUuDcX4s12SQ2blNa/NbOB+/X3O7CkLrdV77ONbowmk83hSlq4CNHmNjKntU3BSKnX
         pWKhu6ypa5cWLo0+ccVQa88OqwjdabO48chVrYBj49Xd0TStc/90N6PLzTbqLB+/UkuC
         w0mRi9+sKG93yI0rTJCp9b3Gv7DmMdSfe/OQ1kxLZLviUeYpAT4xnqcXtaAVa56FG2ms
         8m5D3jDY9L49eDqzg0OPQ5X+NZ2e1WrDOd1I+XnChSHEj+2D88SvT7I8C7Z0+ymXVdBr
         fVIw==
X-Gm-Message-State: AOAM532LZWziOOp0X6/XeAxsCoAKnDGJl3AY/0FjPrHmZ7xjS15ulMPf
        0yDnqo4uatBwWsiLjqIBo1sbPbY52zA=
X-Google-Smtp-Source: ABdhPJzteuY7hk6X/Ppos5vwv99Yvm+wx5wqkkY7lAiNpQklyezDsFYXdhXVPDnvDSXWNqLSSID7Kw==
X-Received: by 2002:a17:906:7d98:b0:6bb:b32b:d3bc with SMTP id v24-20020a1709067d9800b006bbb32bd3bcmr14966126ejo.126.1645446717553;
        Mon, 21 Feb 2022 04:31:57 -0800 (PST)
Received: from [192.168.1.10] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id n25sm5155523ejl.82.2022.02.21.04.31.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 04:31:57 -0800 (PST)
Message-ID: <f12f509c-0ff2-8f83-869f-b91aa7076baf@gmail.com>
Date:   Mon, 21 Feb 2022 14:31:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/2] kernel-shark: Fixes needed by the Xenomai plugin
Content-Language: en-US
To:     linux-trace-devel@vger.kernel.org
Cc:     hongzhan.chen@intel.com, jan.kiszka@siemens.com
References: <20220216082909.614231-1-y.karadz@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220216082909.614231-1-y.karadz@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Hongzan and Jan,

The modifications needed by the plugin are now upstream and I would like to ask you to do one last thing. When you are 
ready with the plugin and its stand-alone repo, please send me a patch, adding to the README file of kernelshark a short 
description of your plugin (couple of sentences) and a link for its repo. This way others can take ideas and inspiration 
from what you did.

thanks!
Yordan

On 16.02.22 г. 10:29 ч., Yordan Karadzhov (VMware) wrote:
> Yordan Karadzhov (VMware) (2):
>    kernel-shark: Add KsPluginsGUI.hpp/.cpp
>    kernel-shark: Load 'ctrl' interface for user plugins
> 
>   src/CMakeLists.txt   |  5 +++++
>   src/KsPluginsGUI.cpp | 27 +++++++++++++++++++++++++++
>   src/KsPluginsGUI.hpp | 22 ++++++++++++++++++++++
>   src/KsUtils.cpp      | 35 +++++++++++++++++++++++++----------
>   src/KsUtils.hpp      |  2 ++
>   5 files changed, 81 insertions(+), 10 deletions(-)
>   create mode 100644 src/KsPluginsGUI.cpp
>   create mode 100644 src/KsPluginsGUI.hpp
> 
