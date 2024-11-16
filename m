Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63958186E2D
	for <linux-trace-devel@vger.kernel.org>; Sat, 16 Nov 2024 15:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731771656; cv=none; b=LQsEev54xMgcsNLKbyd5ppt6CcIawnCx0H2KuzqX5mMj8ZEliYku5XR+yL8vJzIX/UyjuDv74tTo7X11h3TISMxZwRZWLRnJNPCjjGTTSBVJ1BkMaHl30HVdEZVovDMxJbF/N0EPKUQIZ+R05bHbGsSirNcwD8M8j2HIs7K6XM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731771656; c=relaxed/simple;
	bh=Wd+7kLQISUZlzyPvYmSUTVOb8NV4Vyd3OpsFXw6X7a0=;
	h=From:Message-ID:To:Subject:Date:MIME-Version:Content-Type; b=Tvh9MpZv2gh38Sj8Aj86pHaxzSks/BOwYEjz5gl0nJm6qYTh5MdRydkbfQcNeVbqWi01jy9cerW3KF/ULnMAzZrUlgA5eJ8LPuuZdwCK0Ccvt0N0CQwFg/NNazPBF8vPzoudSbRmGxoAYihWUY80DqdtLip/WvXXNSw0bdp8ZX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RffQdH9m; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RffQdH9m"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-720cb6ac25aso2217035b3a.3
        for <linux-trace-devel@vger.kernel.org>; Sat, 16 Nov 2024 07:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731771653; x=1732376453; darn=vger.kernel.org;
        h=mime-version:date:subject:to:reply-to:message-id:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XHEOkgJ64rwJ+cv0sVIqPUmbc8l+iTifR7HzGzNced0=;
        b=RffQdH9mro8+im6hj3v0iVVEGrKensmcqzMb6ZNR0Unx+U75S3qkvl2tVO9AUVtdfg
         x97KISA6KXAuY0LtaHjPHCmL/pKNqXetOQ2Et50VI+U94BfqlVun97XgSWqH+WJiu1eZ
         jNbIZky/DqEZ/9dWyNHam0LuHkxTcjBN8HBQ15KIKNI8Iv20HutGPlC3N4XSV+1EGjgl
         2NAP7tB/dp4nfzF6PyuyboUEk+k+3TL+wm7arDsBYEL7T1VTsGwpJxAHvCly0mBU9Jlj
         b+9RqwUjmaUECGjezGuviMEMQ9Hv6fDixe/yFbzMg7RO3mJ44d4K99N2La+oW+N1PQO4
         6ddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731771653; x=1732376453;
        h=mime-version:date:subject:to:reply-to:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XHEOkgJ64rwJ+cv0sVIqPUmbc8l+iTifR7HzGzNced0=;
        b=klV+Nkpxoz+LNDOfpFxKKXvnxJWd9baiC/HvqUzR5QmwMnF8v57OMEjLa+GFss07s6
         WGX59jWIV/lD8gYu4XWlqEHGqD6iKA8rNlc94Vp2cl3Lmo2U1Z78koZUVh4bKLFQBWMc
         bLYP+scq18DpYIg0Q5PcGuI1A3Imz8cFLqKJW4q3f2WjoJoEJlLkHQKRDyGVdiKiKfPf
         bOgr+idJE/BhpBK3+0NQogREVVxnQgpkwqTYmgUifQvQRtZJtyR629Gx+s5MyXeRmU2b
         xfq+XQTbBVgM7/848oIeeNggzG8wa+6bxY5zQ89jvWmxh5VZMd6Eh569zojWA46R4WaD
         oM0A==
X-Gm-Message-State: AOJu0YzyAMVsNg7GK1NaFBSo8i5Q6OKg+qACIpphCJVoAFrtY3OqM2wk
	8W7k2lrg41PuHYG/Wl/HEXjfkSIW85rPLeJbNdwTIQQoybIXCOWRHeIF6g==
X-Google-Smtp-Source: AGHT+IF1xDuotuqPbwGkLqDA17tkA1pGP5UZub/pHfB4qKGoVQTSndA/vs49C7EwL2OoTmr0mDLP2g==
X-Received: by 2002:aa7:88cf:0:b0:71e:5150:61d6 with SMTP id d2e1a72fcca58-72476d58a6dmr9083625b3a.21.1731771653332;
        Sat, 16 Nov 2024 07:40:53 -0800 (PST)
Received: from [103.67.163.162] ([103.67.163.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724771e1da0sm3281798b3a.145.2024.11.16.07.40.52
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Nov 2024 07:40:52 -0800 (PST)
From: "Van. HR" <vipinrawat07674@gmail.com>
X-Google-Original-From: "Van. HR" <infodesk@information.com>
Message-ID: <d7c53bd48fd6c9eec149bb67d7f4fa00cf82dd62a8f51b219171fb72eb8fcb51@mx.google.com>
Reply-To: dirofdptvancollin@gmail.com
To: linux-trace-devel@vger.kernel.org
Subject: Nov:16:24
Date: Sat, 16 Nov 2024 10:40:50 -0500
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello,
I am a private investment consultant representing the interest of a multinational  conglomerate that wishes to place funds into a trust management portfolio.

Please indicate your interest for additional information.

Regards,

Van Collin.

