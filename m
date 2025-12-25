Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879423C38
	for <linux-trace-devel@vger.kernel.org>; Thu, 25 Dec 2025 04:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766638344; cv=none; b=eBfPAoMtYxTYjqCRjhPwcZ+GPiN9Lk5grQJLhdzGFHxDmi5Ll5bpXEvYIuFOuaqjygiqtukDLWw/yZXRdSMECGBYTXncWfrw0Szfdzj5v0SY5wP68+VhJrRZHkfndn7TXUJNJh7FfazJQJQqGE+27xDgG9tWcbFyeCdv42jKbKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766638344; c=relaxed/simple;
	bh=YT+IxXkexcC+/N1BQntLrSuxfi2EkeIIBxhDEQXV2K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVw1RzglQsKiJyIpkFj8tyY3MjiXzy7/a3B1fZu505CW6qRX8LwYkFcBvMSn5PiplB4wORERUG1/H9FYMuk//cRefdDJadlA7PixoRfl7oFLTVWB4Hm6gQUlal7bK7bCWbHB3YO9PyVDr082BaWd3gtz7wsPgxCVIPcNFMfz3TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g7/ODWMK; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g7/ODWMK"
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-7e1651ae0d5so5053666b3a.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Dec 2025 20:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766638343; x=1767243143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YT+IxXkexcC+/N1BQntLrSuxfi2EkeIIBxhDEQXV2K4=;
        b=g7/ODWMKN7pgBT/r7qbzWlmUq9ffXbhYIgSEWmbeR4vHaGZWaZjx62jKdftVt1oZ/h
         dGcSO8R/ZJK/mdtl4X1Xh/VBCDQugaynIYyUFXmFrLHd5m8T+yU/BX6pPXj7QGn2SgZ2
         64+sFF5b0jxXyDusoTlAd2eolg7vqnrRnAd5wQYLL8UzLk6gI0ywUfDycBo7CvHEtv42
         xtQKcbSm5UMrGW+rmoZAcDufSSUP1mrgbPfZ9Gj3FzdV5WomkesoilMYKhS7FJsQ3Gfy
         EvbD2EQFMGsJ7B1p7S6VU74Kd2B2gxfyP/EdprRQexikcK/qgs13YFGSw572GU77qQjR
         3Zpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766638343; x=1767243143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YT+IxXkexcC+/N1BQntLrSuxfi2EkeIIBxhDEQXV2K4=;
        b=nuiR518KVIEPrONhSljVw2MZZpZQC6S+3qLDPA6UbNFAO4X+bDzKdka5vpWwMYOeks
         26zWhUfmIhadMEfo9PRWsW7AjE/0s7Zg1bu80pz7d/hZl8vQMLdYrPKEuhOhELDS17+5
         VeGM3APoGXGaMluX3aMcYtWHKHnt//fGQVdP1y32t8znWYNLyxQHnpFUK7OkvhwqRQct
         8hTHH8UJpaW3j/LlkCUKa5Q5lNxDtO2niFPsPJVC/FETnf417V8sirLt5v8DGJMGlC8Y
         vgljlwEu+Bl2MkQTqU7iK/V3sPcBffjJShBLJoiGlpsiwIhDb927lmS+uTU+QVRNypvj
         RtyA==
X-Gm-Message-State: AOJu0Yx2SQ6i1XMzEZdhEBxe9VigdBiSn6fnHNbAI/aUhj/KjO4yT868
	/8aZjVQzNQde1WFdm1iuzRY9eO7T/CmA2HRr9+Y3HQrrXSqzrkLah618
X-Gm-Gg: AY/fxX6EDcZALKCm5Va9EtHrqY//fpNZV+kOyuZtp612QTTzwfnCYq3QxDFK3VmVuuC
	i3lkdc76x9EPoamTIoCUJ/zFqlhUMmHisY9qrCBmcRvPuO/JBbNHXWUI/3S5a2vjUXAYGSPHujP
	tD3SnifIxfR2OaTnK5mk5atItE9Ps7EBJ3+gWI/wy4BVx88Hkx3niCzFdN9kujbCuM10A8ItF7w
	YsTD1GLb0+r36WpmcU2KHCbUubBXTzbgOzy+3CHa9K3gXd0vKH3aft73s9Z2xgy26v03PducFJQ
	MkC3TVrSp4kesrPZ8XG/4IXBbh4dIMpjb6rxLBdNcg6+MLnxLmTnhtDeg2sXdHum0nnF5DhNyla
	7AStj/IhpDTu6NNvhB3/bMsEdcosSWCIdgtKAc6YN3oQR0x4DBO5BvSgVjEevQI4mzKv5JVsHRq
	hspD1OPpvgrRx2SPiNk42r+cz4vtpd8NPTWa8=
X-Google-Smtp-Source: AGHT+IF14R1CKiEvleqrHQQ5Yw9JK6ZzraGhzYjBVaIxnHgh5HsrBrAPQzGxsMqPwj+0ZqSiepaLkQ==
X-Received: by 2002:a05:6a00:35c4:b0:7e8:4587:e8d2 with SMTP id d2e1a72fcca58-7ff66a6ea58mr15378581b3a.69.1766638342648;
        Wed, 24 Dec 2025 20:52:22 -0800 (PST)
Received: from DESKTOP-J2JE76D.localdomain ([183.193.49.53])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a84368dsm18501984b3a.2.2025.12.24.20.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 20:52:22 -0800 (PST)
From: Wenjun Huo <huowenjun.dev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Wenjun Huo <huowenjun.dev@gmail.com>
Subject: Re: trace-cmd: question about explicit host endianness setting
Date: Thu, 25 Dec 2025 12:52:05 +0800
Message-ID: <20251225045205.7035-1-huowenjun.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223154900.717ab7ec@gandalf.local.home>
References: <20251223154900.717ab7ec@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Steven,

Thanks for the detailed explanation and historical context!

I'll prepare a patch to remove the obsolete tep_set_local_bigendian() call
from tracecmd_alloc_fd() and submit it to the list.

Best regards,
Wenjun Huo
