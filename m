Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A08C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 14:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6245D60E74
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 14:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243278AbhJKOZH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 10:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241005AbhJKOY6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 10:24:58 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990EDC02B857
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Oct 2021 06:55:32 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id t16so46302326eds.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Oct 2021 06:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a0fnLBnz62ViGC6TOsy1yL8WTqhmNBgUAvXejUmaCJk=;
        b=onmVad9WWU//HHLg6YKf/yW0XA6VE3cryZNlq3GUiTV5ShExlPs9tjg+LBSntDPICO
         kiAUHs/QxeUYxY8uEpgEahhwJiwt+I2sMJc045YdczdEugSsJYCHCWzh+E1lfv0Bs/VP
         lUWW9AigUYcIY1vXccKrfmjZBFh55NcnjUMTUQfpO1XcJ8GLnmNRZpwi98HCw2kpCJXD
         nuaWUv6ztl3WfofOX6/0S26ND5kP/0GOR2j15YNlo26jG2SaN3qCoh+cF9e9+xzjG7Fi
         uSiczDQ/mwcZr1OcmDDen3LbR3qZ7bvwmbeD5d+O6RxOa6H4ALgHmaLaPSlCZcuexGsA
         EdjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a0fnLBnz62ViGC6TOsy1yL8WTqhmNBgUAvXejUmaCJk=;
        b=YVnzAn9sFEZxTtTylH8wdNHceGU1XJFCfLnCnOsthVQwzLMAfwvePDqXHJ/sx5YYdE
         2gbBctjpIKyq/+LTXGPye9xy2/sdmsI6oGF35g9E/1+EVBzXWv2UZi15dxr67r0spoLu
         g8lmKH98v3MgRCaZacaG+h/sqsVGJ3YeKCRA4h1O8F+3SS8OSj/J4wOkAZByZF3gwEFx
         LVrGnirAt+UMoZNxYqlLkHvaV90vyn8RvPgMwh4lThQ62UMzVjWR367v01QAt7GCj3V5
         9ErWVIRJR7LWB6hCnHw06o6agmhI3y5hzDWmFacBr0sIydXoLzKeHxj+bFdGBf5LgMA2
         re6Q==
X-Gm-Message-State: AOAM533B+MQSLtsBxn3g/jLzcIHaEKzqDx1tOdchd7B57U41XTwsgQWB
        S4QgGiAI56HiVe5Nwj86kXaqFqXfHOh5Mw==
X-Google-Smtp-Source: ABdhPJzlenTMapHrvCmz76Xbo+QAzXGduuP26sOjIUzEqr1Uvq+1/NDsOeeBTSInYpN/HmGUO/O0eQ==
X-Received: by 2002:a05:6402:4410:: with SMTP id y16mr31006845eda.366.1633960530848;
        Mon, 11 Oct 2021 06:55:30 -0700 (PDT)
Received: from [192.168.1.4] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b3sm3518251ejb.7.2021.10.11.06.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 06:55:30 -0700 (PDT)
Subject: [RFC] Modifications of some 'hist' APIs
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20210924095702.151826-1-y.karadz@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <5439fe13-8d78-2fe6-3749-5e60cf10151c@gmail.com>
Date:   Mon, 11 Oct 2021 16:55:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924095702.151826-1-y.karadz@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven et al.

I would like to suggest some further modifications of the current APIs of libtracefs. The problem that I am trying to 
solve with this modifications is the unnecessary and potentially confusing variety of patterns used when implementing 
the APIs for dealing with 'instances', 'kprobes', 'histigrams' and 'synthetic events'. I believe that 
unifying/templating the structure of those APIs will be beneficial and will make the usage fare more intuitive. I am 
posting below a pseudo code for one possible implementation of such template APIs that can be used as a starting point 
for a discussion.

/**
  * tracefs_XXX_alloc - allocate a new tracefs_XXX descriptor. This only
  * initializes the descriptor, it does not introduce any changes on the
  * system.
  *
  * @arguments: Some arguments specific for the type of the object ...
  *
  * Returns a newly allocated tracefs_XXX descriptor objext, or NULL in case
  * of an error. The returned instance must be freed by tracefs_XXX_free().
  */
struct tracefs_XXX *tracefs_XXX_alloc(arguments);

/**
  * tracefs_XXX_create - creates new tracefs_XXX object on the system.
  * This method calls tracefs_XXX_alloc() internally.
  *
  * @arguments: Some arguments specific for the type of the object ...
  * This function should not take an instance as argument. Otherwise the
  * same instance will have to be passed to tracefs_XXX_destroy(), which
  * can be a problem in some more sophisticated use-cases.
  *
  * Returns 0 on succes and -1 on error. On error, errno is set to:
  * EBUSY - the object already exists on the system.
  * ENOMEM - memory allocation failure.
  * ENIVAL - a parameter is passed as NULL or value that should not be or
  * a problem writing into the system.
  */
struct tracefs_XXX *tracefs_XXX_create(arguments);

/**
  * tracefs_XXX_find - find a tracefs_XXX object that already exists on the
  * system. This method calls tracefs_XXX_alloc() internally.
  *
  * @arguments: Some arguments specific for the type of the object ...
  * This function should not take an instance as argument. Otherwise the same
  * instance will have to be passed to tracefs_XXX_destroy(), which can be a
  * problem in some more sophisticated use-cases.
  *
  * Returns tracefs_XXX descriptor on succes and NULL if the object do not
  * exist on the system or in the case of an error. On error, errno is set to:
  * ENOMEM - memory allocation failure.
  * ENIVAL - a parameter is passed as NULL or value that should not be or
  * a problem writing into the system.
  */
struct tracefs_XXX *tracefs_XXX_find(arguments);

/**
  * tracefs_instance_destroy - Remove/clears a tracefs_XXX objext from the
  * system. tracefs_XXX_free() must be called in order to free the memory used
  * by the descriptor itself.
  *
  * @obj: Pointer to the tracefs_XXX descriptor of the objext to be destroyed.
  * @force: If false the object is not guaranteed to be destroyed. If @force
  * is true, all tangled objects that prevent the destruction of the object
  * will be destroyed as well.
  *
  * This function should not take any other arguments.
  *
  * Returns -1 in case of an error or if the object failed to destroy.
  * 0 otherwise.
  */
int tracefs_XXX_destroy(struct tracefs_XXX *obj, bool force);

/**
  * tracefs_XXX_free - Free a tracefs_XXX descriptor, previously allocated
  * by tracefs_XXX_alloc, tracefs_XXX_create() or tracefs_XXX_find().
  *
  * @obj: Pointer to the tracefs_XXX descriptor objext to be freed.
  *
  * This function should not take any other arguments.
  */
void tracefs_XXX_free(struct tracefs_XXX *obj);

/**
  * tracefs_XXX_YYY - Method implementing the user action 'YYY' (can be
  * enable/disable, start/stop/clear, ... etc.)
  *
  * @obj: Pointer to the tracefs_XXX objext for witch the user action will
  * apply.
  * @instance: Ftrace instance, can be NULL for top tracing instance.
  * @more_arguments: Some additional arguments specific for the type XXX and
  * the action YYY.
  */
void/int tracefs_XXX_YYY(struct tracefs_XXX *obj,
			 struct tracefs_instance *inst,
			 more_arguments);


Thanks a lot!
Yordan


