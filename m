Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF3CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Jul 2022 18:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbiGMSkB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Jul 2022 14:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiGMSkA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Jul 2022 14:40:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2F4248C2;
        Wed, 13 Jul 2022 11:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B26B61D17;
        Wed, 13 Jul 2022 18:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE50C34114;
        Wed, 13 Jul 2022 18:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657737599;
        bh=anRZ2fJ+aqOYBp3yiMxv5Ju/dg+jiE4LeEVNzaKoXlM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NL0r5L02eFjiasaVyTonmWb80VGpWinaWaFg7a1YNGrQ3ejrBwycX7l9ke8ffFcX5
         kmjK2gYEySQL7/7Oqz3Tdo+CLMI+8vGn142t3R5ynG7W73VVvhMPaanTVT5XViAvwh
         QA6C4NiTyphK8EorjZqvZTcNDIgfUrR7nab65Efg8mdm7lnXxEMqfwF7xvUGHDQqQK
         5eyEaqn01hD34PnuDbyfvKI3fR7joNnpCs6rqAXop/S2T49gxjs62qj9+lQVLDn4Rd
         li1LG1LVZROoWe2VYAuAmy4V77DbxmzlQa/k9gOo/0S2T8sSjAppozB9dZntDkwEvh
         ZWOTrL2owmuCg==
Message-ID: <2dcb1f19-febf-c17e-a933-5779a69d283f@kernel.org>
Date:   Wed, 13 Jul 2022 20:39:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V4 04/20] rv/include: Add deterministic automata monitor
 definition via C macros
Content-Language: en-US
To:     Tao Zhou <tao.zhou@linux.dev>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Gabriele Paoloni <gpaoloni@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
References: <cover.1655368610.git.bristot@kernel.org>
 <e9c4b813d4e021cbba10203005cbc22ecef5fa80.1655368610.git.bristot@kernel.org>
 <YsXa2w90ej9KjI7D@geo.homenetwork>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <YsXa2w90ej9KjI7D@geo.homenetwork>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 7/6/22 20:56, Tao Zhou wrote:
>> +/*
>> + * Entry point for the global monitor.
>> + */
>> +#define DECLARE_DA_MON_GLOBAL(name, type)					\
>> +										\
>> +DECLARE_AUTOMATA_HELPERS(name, type);						\
>> +										\
>> +DECLARE_DA_MON_GENERIC_HELPERS(name, type);					\
>> +										\
>> +DECLARE_DA_MON_MODEL_HANDLER_IMPLICIT(name, type);				\
>> +										\
>> +DECLARE_DA_MON_INIT_PER_CPU(name, type);					\
> Why the global monitor declaration use the per-cpu monitor macro.
> Global monitor has its own DECLARE_DA_MON_INIT_GLOBAL(name, type);
> Or am I miss something?
> 

Pure miss attention from my side.

Fixed
-- Daniel
