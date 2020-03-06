Return-Path: <SRS0=llO+=4X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4069C10DCE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Mar 2020 11:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 984DA20848
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Mar 2020 11:18:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YKbms9DW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgCFLSg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 06:18:36 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:50896 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgCFLSg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 06:18:36 -0500
Received: by mail-pj1-f47.google.com with SMTP id nm6so938959pjb.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 06 Mar 2020 03:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=dYENKnWfTVKJzAhzFURHfhecVQB4ZcPcrgFF4ccOeV4=;
        b=YKbms9DWwnx4qahpFkzhESdacHzE0eo0b0gNENMA8ag5zpjxkdtbu937PEQTnNRoZy
         U9YS9IZ8Ghrv/RHG15x/it2Kg5CgJxFj/RxZqCE8nnrHgN047iTGH4GqjIQb/o5e4AAi
         CzRjdFrlbu+ICLLJ9ZLLRDFmcs5dORbJ2bSPGvJXlI/G6D7jxjPU1Ezm+3ih+q27YOe3
         wJ0NKFPeVuOCEd6uU3onMOsNlSFOrmMkvjwsl8/RGp82Tr8r/s9TYU8V5pVNmQcsh4Jv
         Z1kduJ7f8FNzArDGmtji24UTtjQpQZQ2mKVkNFG9CaVXnhcIVyFM9EBOiq/XRKld6UEX
         p9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=dYENKnWfTVKJzAhzFURHfhecVQB4ZcPcrgFF4ccOeV4=;
        b=PjI2Ez0uMaRuFlLVS5/X16BxUH2+pNtftEjBXZfP7owtwZG7G+Fl9OfQXaWw43Lmzc
         9JG4euGFLgB50LXEdn6TNrMf5n/ZVESA0Z26HRvq2yUa5vkgpUn47bWVO6gNffKGT262
         PZRcy6aJX2jkp+bbptjMopbGHQ2pAtz3uN+P5rHLqt9wzcpsx1z2EWMxERCMw/cpIyQA
         KPe0HXaJWqeQs9CCsP+DfTp5cjrqJIJqG3gyhtQx22IKtKP/HMIB1pub4V/gqPQxG49a
         jzTH/DEaikfr2wZhrenORgaHGkO//M9ON++QVzKb3iIFw0rgdASk1mPz7QtiXd7OmbVT
         QjCA==
X-Gm-Message-State: ANhLgQ2vyunY01XxbrxW/oswoT4NiLYy5rniZtG5ulrj/Y5/lwM9mjB8
        9zNVkYFmASMSOephqbQliEIS5DRIdCPQeIjJ+rc=
X-Google-Smtp-Source: ADFU+vuFRJSjMEDU7vgTm3vFBmVYuR1tS+Hoa+P3mh9E/RsfzFgwqcD3i/ty13j/SggANM247uwaUrVcN6MCn6wZpjo=
X-Received: by 2002:a17:902:467:: with SMTP id 94mr2514489ple.302.1583493514882;
 Fri, 06 Mar 2020 03:18:34 -0800 (PST)
MIME-Version: 1.0
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 6 Mar 2020 13:18:23 +0200
Message-ID: <CAPpZLN701xFs=Nt6Byic8M+-nysPzmB2BVbLaG-oZ3on5LcZ5Q@mail.gmail.com>
Subject: KernelShark 2.0 alpha and host - guest timestamp synchronization
To:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi all,
I have tested the latest KernalShark 2.0 alpha and "Timestamp
synchronization of host - guest tracing session " patch set. The only
problem was the missing integration with the new lintracefs, submitted
2 patches to fix it.
Steven, please check if there is there is time synchronization data in
the guest trace file:

 trace-cmd dump --options trace-guest.dat
 ...
        [Option TimeShift, 44 bytes]
0x6470A6C9720B8D78 [peer's trace id]
2 [samples count]
    34248057155152 180882280920 [offset @ time]
    34248057142908 186149766692 [offset @ time]
 ...

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
