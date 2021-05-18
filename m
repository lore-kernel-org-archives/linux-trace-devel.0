Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F5AC43460
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 May 2021 14:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29FB660E09
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 May 2021 14:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhEROYb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 May 2021 10:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbhEROY1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 May 2021 10:24:27 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19619C061756;
        Tue, 18 May 2021 07:23:08 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id o5so2438421edc.5;
        Tue, 18 May 2021 07:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BI6frBpCvLWdRpsaa3Qd2jxeaI8MxUUevm7vNpxNyAE=;
        b=n60TqLkGxp9IbkcR8I7NuOMyu+K1wTJscNybucvKasHcApE9T0JKtK87REXKa2Xftg
         bmvoU3wYCklEqwTN0pl5sNEsxQ3BSE1IwByUS7pN1KHdAYwJilTd3o+qjgPniJXwIyTi
         mXZDcuipon5wtAwEsmUbEUDsDwMp/tdJlVi8aatz0DWevYMQv971XhZqXgimDHeezPIj
         qW4OoPI/B+JICszTBbMxdlDhhV4YoqYQtex3ql/MP0z/o8/Rb5xGLalp7E1YDF2OR4mo
         ZyOpDVNz1QZjr5/LOQQHHxw5oPPshINw756jsWUXUqcRGquUFHHqLW0cixAcv40AiZZu
         Vu7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BI6frBpCvLWdRpsaa3Qd2jxeaI8MxUUevm7vNpxNyAE=;
        b=Lqn/j19MAYeGu246KUIF6XEq+SgwGTTxbbgSo7gdJl5ycbQsDrIvdOr2aMfym/vYHE
         IYNUTB86EJdN/yX9VCoeuG7JnbYrK7v5lG34+9xmKqIZoNvrFMiMqq0QUmOZC4+GNQ5u
         nlB+MjCBKa+L2rxo6b2r0Iak4P2WcNHUb4WBMPA5L+qCfDo89VuHQqXHg0h4ECprzw1P
         Vykv+tDwKCtDluh7/H+/3eiDABrwrwGEYrJTglhOcRwSpGM2DUlMVBFo5e/a3FQxzZYW
         5Dh686edSuiepCJOsStJyxVlGDzHCur13kkMZ3MdatUx2PM2hi8Wps6eYdbv647b7RBv
         3CPA==
X-Gm-Message-State: AOAM530iZX+KccEFvElQVJ+Y4SCsH8cb64Pdmm/fAuP3MzMvWZAOO03X
        6bNQJCpKxnfukIJf6GTOt5k+Y/bJspY=
X-Google-Smtp-Source: ABdhPJwKe6n3HKpvi8KSV194C5ZmIwIvHH8ZA5/J8QYLNELFwnq0mWZy8fjiajidBLz1c8jad9XEqQ==
X-Received: by 2002:a05:6402:3098:: with SMTP id de24mr7270257edb.339.1621347786578;
        Tue, 18 May 2021 07:23:06 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id y25sm13176612edr.63.2021.05.18.07.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 07:23:06 -0700 (PDT)
Subject: [ANNOUNCE] KernelShark 2.0
To:     LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Linux-trace Users <linux-trace-users@vger.kernel.org>
References: <20210410094046.0a23f960@oasis.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <1c9f9a94-0ae3-e5f6-0cd8-79565d9d53a8@gmail.com>
Date:   Tue, 18 May 2021 17:23:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210410094046.0a23f960@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I am pleased to announce the new version of KernelShark has been released:

KernelShark 2.0

https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/snapshot/kernel-shark-kernelshark-v2.0.tar.gz

https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/

Major changes since 1.3:
- Introduces Data streams:
   With the help of Data stream, KernelShark is able to load and
   merge multiple trace files (streams). Each stream can have
   different plugins or filters, registered for it, which means that
   the raw trace data of the streams can have different formats, and
   will allow for a great degree of customization of the provided
   data visualization.

- New design of the plugin interface - instead of having a single
   interface for loading the plugin, we now have 3 different
   interfaces:
   - The one that exists in version 1 of KernelShark is now renamed
     to Data Processing Interface (dpi).

   - The first new interface for loading can be used to register
     user provided implementation of the Data stream readout and is
     called Data Readout Interface (dri). Via this plugin loading
     interface the user can open trace data having an arbitrary
     format. In order to make this possible the user has to provide
     a plugin that contains an implementation of the data readout
     methods defined by the Data stream and to register all those
     methods.

   - The second new plugin loading interface is called Control
     interface and can be used to provide the plugin with an access
     to the GUI's Main window object. Via this interface the plugin
     can became capable to modify the GUI.

- The modification of the C API are used to implement 3 new
   plugins:
   - KVMCombo plugin: The plugin allows the user to visualize
     the execution flow between the host and guest virtual machines.
     It exploits the concepts of "Data streams " and "Combo Plots"
     That allows to have two normal graphs from two data streams
     stacked together (on top of each other). The plugin uses a
     "combo" between the task in the host that emulates a virtual
     CPU and the corresponding CPU graph from the VM. The plugin
     draws additional graphical elements on top of this "combo",
     helping the user to intuitively interpret the data and see how
     the execution flow goes from host to guest and back.

   - LatencyPlot plugin: The plugin allows the user to visualize
     the latency between two events under the condition that the
     values of given data fields in the two events are identical
     (for example having the same PID). The plugin also registers
     its own dialog, that allows the user to select the events
     (and the matching field) to be visualized.

   - EventFieldPlot plugin: The plugin allows the user to visualize
     the recorded value of a given data field from a given trace
     event. The user can select the event and field to be visualized.


Yordan
