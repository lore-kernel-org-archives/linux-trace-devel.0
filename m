Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913EE171678
	for <linux-trace-devel@vger.kernel.org>; Tue, 28 May 2024 15:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716911464; cv=none; b=JM92VnqvP2gb3cHjFPXBQ7bVMtJkFj0MKZB8BQN1YgHW/CjqaDmBtdGGic9NZScNw+/u1zmOWbS2137Uv+JsfNFz9mgtVSrOIG8f8bB6aSuS35NfscmVLQ3Jqc1wHFe7Kt/NnRTXqaBYE64gKCQkOmJfkbNtxlr4e6Kr518GxXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716911464; c=relaxed/simple;
	bh=hhPwvJOjXf3jc9iPbPcqNSJipckt+TH6z7Ut4MijP1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=shFl5TBBBpVchK+p+LCWxEIdYb1ddt/DuRa7I+LLaJAziW7FwGdhnvGxe5md+RD3cFcUOFMEmv6Qhj+VThxQ0seod+BvKIu7dxNTe0by1+GstNVUm0YPYElNfQ1E35+WCt11i5tvkhuXF5Y3rAmBeMy8IPjjJhwKD0TdR6fHeM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xhCSuyMt; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xhCSuyMt"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-36c6056f7bdso480695ab.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 May 2024 08:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716911462; x=1717516262; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhPwvJOjXf3jc9iPbPcqNSJipckt+TH6z7Ut4MijP1w=;
        b=xhCSuyMtKhtZxttZrhW1RyRkkRrsWNfR2GVdQPBbcBVpIj6o9FwHxA3UgI8dFfL5NS
         xv7RB9rszMHvyXv0Wco2nzRg1d5t+iGa5JJmmVLYq+LCQGlxA4hkVJvfpRWZ2Sxs7WUm
         sTHbyAmk8NE3g1+PLYQ2esY6c9DIqemKnDmuN3DTZ0A8nPSX+fLzKIRUf26KMlHd+lI3
         o23AQiA+XVVb2b7PMlySxFE/WZHI2VLJe9nKOmrl5yKFIzSTlr5wlNJmW3DzH2M3uTY5
         nDGD9Dro0r2zoXFrwCda9nX8r+r7NGesiJT8Wj1Bd0fNamte9rsO7mTG25EUwN0rPJhk
         sEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716911462; x=1717516262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hhPwvJOjXf3jc9iPbPcqNSJipckt+TH6z7Ut4MijP1w=;
        b=OWEY/mC6YoTvI9JG/FCudL9QGJUEzqZn6pP7QplZFF4vdafz6akb3GkIJ6T2KYEHnq
         Jh8GRj68bXHgNYFYhpP53hBpU1pP5dgigw/X/Q4omrXNRX7GFGerPlrulIWSV4oufcXI
         VFMwvFhUMP9TmhPsgTMtvJbHaUgye7tVFDuKOXTmtUlPo3iafzoQzMBRMb+yheCf/YfZ
         GnUNpw1dIjd9RK4ap2EqBXcd0Z3IpfFX9r5/NcDp1oGfnM52ylB4JbwWq/7kVaIQ4Jk4
         JK0P8gNliLVEQmnIgs/rvpzvZCmRxWbbk8yQm+zknRVSxlls1fsD2y6uK2GVgmjVWWHP
         ksCA==
X-Gm-Message-State: AOJu0YzIMmgsYLD3QQ6nf+tUYI7Z2xWTUaK5iI/lZ7l5KOLyg+CxXUSf
	dYcNaNjhbIFuWfKUr9FYLHaJAkn8By2suVrcBOcla0qTdtvHDEPKI+Y0R0GBjlGxOOz/DT1hOq9
	zYFbGRXj9txFYM0r18PIBsQkCVApli7cXDA85p7Fhe9I+scdH96Ah
X-Google-Smtp-Source: AGHT+IGOEMyzLPzslQXhlOs2Ev+44f0KcbBsGlSD7JgnJUmUGwuBVWu3alGpKqr5ysZHJ9CNJv3wZCFCyNKt6MlIKqM=
X-Received: by 2002:a05:6e02:10d0:b0:374:5f1b:1127 with SMTP id
 e9e14a558f8ab-3745f1b1366mr2808765ab.24.1716911461474; Tue, 28 May 2024
 08:51:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240430073908.1706482-1-irogers@google.com> <CAP-5=fWQOB5QcrQ2rst0uq-B2A0BtNzSatFdtqG8+4Ba80G8MQ@mail.gmail.com>
 <20240516204041.63f986be@rorschach.local.home>
In-Reply-To: <20240516204041.63f986be@rorschach.local.home>
From: Ian Rogers <irogers@google.com>
Date: Tue, 28 May 2024 08:50:49 -0700
Message-ID: <CAP-5=fVN2JLOWjYJ=fi1LvW6+XJXrEDp6PHV3LOEDkdtxxYsjg@mail.gmail.com>
Subject: Re: [PATCH v1] libtraceevent: Fix event-parse memory leak in process_cond
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2024 at 5:40=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Tue, 30 Apr 2024 01:03:15 -0700
> Ian Rogers <irogers@google.com> wrote:
>
> > > print fmt: "%s%s%s%s%s", __print_symbolic(REC->exception, { 0, "#" "D=
E" }, { 1, "#" "DB" }, { 3, "#" "BP" }, { 4, "#" "OF" }, { 5, "#" "BR" }, {=
 6, "#" "UD" }, { 7, "#" "NM" }, { 8, "#" "DF" }, { 10, "#" "TS" }, { 11, "=
#" "NP" }, { 12, "#" "SS" }, { 13, "#" "GP" }, { 14, "#" "PF" }, { 16, "#" =
"MF" }, { 17, "#" "AC" }, { 18, "#" "MC" }), !REC->has_error ? "" : " (", !=
REC->has_error ? "" : __print_symbolic(REC->error_code, { }), !REC->has_err=
or ? "" : ")", REC->reinjected ? " [reinjected]" : ""
> > > ```
> >
> > Some more context. The place in the input where the leak appears is of
> > a string "?" read as a token at:
> > ? "" : __print_symbolic(REC->error_code, { }), !REC->has_error ? "" :
> > ")", REC->reinjected ? " [reinjected]" : ""
>
> That probably is the cause. That should get handled.

Thanks for landing this, glad I got the logic right.

Ian

> -- Steve
