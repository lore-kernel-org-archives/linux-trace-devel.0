Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876C81BC3
	for <linux-trace-devel@vger.kernel.org>; Tue, 28 Nov 2023 12:33:17 -0800 (PST)
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-77dbdc184fdso15665385a.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Nov 2023 12:33:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701203596; x=1701808396;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cJsib2aplLvyQh61u6Y+Mk/QND+pvzCaVODmEMS3e7c=;
        b=gT2WGIM4OFSvYaELtzoCuiK6TaR7Y1hjOabqy1EKRgFCs+J3hSISOrHXuPQ+O11kUG
         e3U8blKCj/UmnJvADgs9GhlVqGnuhDVm+Mh9UhKE06IlbHOQhfZxb/Hh5nJ61f+E8inK
         zk1abVbtVgVAcZdIyXNkxtjsBx/ONTSUcxpntTNtqkRdYtxlQOqaYQQWuqCQHM2qAwmQ
         thUK5t07PFMis7SyPRv1cdLF4qHbICLotym2b7rsBJ7exqFJSX5ILXVmLoCyBor5DXDK
         W1OAympqlZdpxpGpF43qo+r321E0a+B84fs2ey3eCP+8LM/N8SI/Yk2ahsmYsfS7/WWF
         RISA==
X-Gm-Message-State: AOJu0YxkvvClBcf35tayyLExdVJ0VsIdEVfXrmDCd4attglBv7OnhYQW
	9nRGuqsWxxKhmA6+woSJ8no=
X-Google-Smtp-Source: AGHT+IEYXr2iPWW3ITYtZ18xROlgCLv030RF3A4m2DSx6oLBGtjW/6l+bTJv/7JyxoK9FaAYVPUwWA==
X-Received: by 2002:a05:620a:8103:b0:77d:9d8c:a5fd with SMTP id os3-20020a05620a810300b0077d9d8ca5fdmr12939536qkn.34.1701203596063;
        Tue, 28 Nov 2023 12:33:16 -0800 (PST)
Received: from maniforge (c-24-1-27-177.hsd1.il.comcast.net. [24.1.27.177])
        by smtp.gmail.com with ESMTPSA id pz18-20020a05620a641200b0077d8a162babsm3360861qkn.13.2023.11.28.12.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 12:33:15 -0800 (PST)
Date: Tue, 28 Nov 2023 14:33:13 -0600
From: David Vernet <void@manifault.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	kernel-team@meta.com, julia.lawall@inria.fr,
	himadrispandya@gmail.com,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] trace-cmd record: Use copy of PATH for strtok_r()
 operations
Message-ID: <20231128203313.GC431764@maniforge>
References: <20231128153024.6e0d40e1@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128153024.6e0d40e1@gandalf.local.home>
User-Agent: Mutt/2.2.12 (2023-09-09)

On Tue, Nov 28, 2023 at 03:30:24PM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> As strtok_r() modifies the string it is parsing, using the environment variable
> PATH to find the paths for execution causes it to be truncated when reused by
> exec. Instead, make a copy of the PATH environment variable to use to parse the
> paths.
> 
> I had this fixed in my repo for some time and never pushed it out, but it was
> eventually reported by others.
> 
> Link: https://lore.kernel.org/all/20231128192435.36507-1-void@manifault.com/
> 
> Reported-by: David Vernet <void@manifault.com>
> Fixes: edf9424029cc ("trace-cmd: Open code execvp routine to avoid multiple execve syscalls")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: David Vernet <void@manifault.com>
