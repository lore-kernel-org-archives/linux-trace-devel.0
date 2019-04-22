Return-Path: <SRS0=qNMP=SY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592E3C10F11
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 11:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 255E7204EC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 11:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qGww9GMX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfDVL3y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 07:29:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54443 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfDVL3y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 07:29:54 -0400
Received: by mail-wm1-f65.google.com with SMTP id c1so14051205wml.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Apr 2019 04:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4F+wH+gEttN2eVSRs74kQtbZ/kgaiQR01yPX2WdjdvE=;
        b=qGww9GMXLzivToGgLagdDADpv4KY6IJIcaCeJCHNoIgqflYImkY9yIFXEcgCe20Cwk
         DmpAwGe5lAkNf6lOzZpGTO2vM/hAp3q3JE7OVjrbx+wNqDn8z3s4/7YnWY6UMZqPoMf7
         8BmZZ47XkebSK6NmBF5bFXTiRNYQGxFlIWtcJIgUcj7cHael0zQNX6ONZSjyLlEWD9Wb
         PZYG42gwY+6c/PYTbh0c/+q3DP0SXPB2nbU9283U7Qzz2fgk590yH7T6PwO0PUSvIQnc
         AC75WcgAGqTKnEuEC4SeloImHBGhErtSLBdofu+IYqEq+t1fuO7O84/h1SkQlqF8A7+K
         xqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4F+wH+gEttN2eVSRs74kQtbZ/kgaiQR01yPX2WdjdvE=;
        b=fiWOH6nOikJv9rBvroNQfPawZ0kyNBopOkcotgSJvQd3p1sP2Uci8hh8Buu9JFQKWi
         rqD7M0LPQLY4aCZjjj+OQ7YHPRzCPC7sDLCx4iTsWWprCtqPUDOXoM+J3Tl1WWEqzjBr
         F+cN45gCh4etTMGamnvK2DNE7gzKZpMVGm/2UQxL2Wmxmjj5t4wPvP0sGdptRuMC+kn5
         eX0cIXzz4tgCChdhAIXCKLrTDakDnaBEryP3W8a92aBELuBkHZtU3I2IStehD0xsGtsj
         AolAQ4wn8rQ/m/X3mWl1JP+1+MOU+Vm8R9Kv96OWsF5Kof5sAc6nZxvtZCDokbZtlkwy
         b/UQ==
X-Gm-Message-State: APjAAAXPLko8j2XXSa0jU36lL3YP9ZlkPPp3m9pbUv78i+bHhFcxPInN
        j3W71H0y+iPeb2/sQMuT8juDEd0r
X-Google-Smtp-Source: APXvYqwWB7jK2YdNe4PD96lAEvLnoh54od2Jf4rpojTlsfHQo7/PTG9QQg8tGIex6XQ7if402m/2OQ==
X-Received: by 2002:a1c:f50a:: with SMTP id t10mr11408098wmh.86.1555932592484;
        Mon, 22 Apr 2019 04:29:52 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id m14sm4019806wru.51.2019.04.22.04.29.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Apr 2019 04:29:52 -0700 (PDT)
Subject: Re: [PATCH v3 4/8] kernel-shark: Add logic for the plugins search
 path
To:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20190419135036.19340-1-ykaradzhov@vmware.com>
 <20190419135036.19340-5-ykaradzhov@vmware.com>
 <20190419132815.2820b6af@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <06f28287-93ee-ffc9-3603-3b67c8e1aa24@gmail.com>
Date:   Mon, 22 Apr 2019 14:29:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190419132815.2820b6af@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.04.19 г. 20:28 ч., Steven Rostedt wrote:
> On Fri, 19 Apr 2019 16:50:32 +0300
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
>> +char *KsPluginManager::_pluginLibFromName(const QString &plugin, int &n)
>> +{
>> +	QString path = QCoreApplication::applicationFilePath();
>> +	std::string pluginStr = plugin.toStdString();
>> +	char *lib;
>> +
>> +	if (path.contains(KS_DIR)) {
> 
> I'd rather not use the hardcoded path. If I build the code on one
> machine, tarball it up and move it to another machine and extract it,
> and then run that code from that machine, I want it to still use the
> plugins for that machine.
> 
> I was hoping to test:
> 
> 	string = cmdline_path() + "../../kernel-shark/lib/";
> 
> If that exists, then we know that we are in the source directory.

I don't thing this is a good idea. If we search for plugins in a path 
that is defined like this:
  cmdline_path() + "/something/hard/coded/lib/"

Then the GUI will do one thing when started like this:
./kernelshark

and anther thing when started like this:
bin/kernelshark

and this can be very surprising behavior for the user

The other solution has it own weaknesses, but at least it sounds like a 
simple rule: "If you want to use the compiled version of the plugins you 
have to start the GUI from the source code directory used to build. 
Otherwise the installed version of the plugins will be used."

Thanks!
Yordan



> 
> -- Steve
> 
>> +		n = asprintf(&lib, "%s/lib/plugin-%s.so",
>> +			     KS_DIR, pluginStr.c_str());
>> +	} else {
>> +		n = asprintf(&lib, "%s/lib/kshark/plugins/plugin-%s.so",
>> +			     _INSTALL_PREFIX, pluginStr.c_str());
>> +	}
>> +
>> +	return lib;
>> +}
>> +
