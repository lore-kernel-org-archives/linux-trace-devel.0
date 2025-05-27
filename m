Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79F4274FCE
	for <linux-trace-devel@vger.kernel.org>; Tue, 27 May 2025 14:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748355728; cv=none; b=qvADd0drAcKpLwYGvX58lcHOlTApHDZyxAffOPRMCJLxt/B+LPSYv90LdXJpvOR3YU6HnksRnm8LAt1N1PUcr6xTlse7Ms91YXRGt1xd7J1tR8E/JX0mQw9hAsjL0zHii7oEuCdKQGfaucc8nliPdnkggVseNJ3qVTT4xj/qIrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748355728; c=relaxed/simple;
	bh=0+ZEYujXVWg3xUaL+UIA3WNZGh9n0UIdbpqeJ1Z18f8=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Content-Type; b=VRajbeEkG+8uk59U3SlPB0FwQa5WQ3YboKgQA+/XAR4/QHmFZX18PXzXNvm/jEn/rCTjArXj0hOqFEmOVDrL0L7PvN6bmXE47MsOXCFrdpXnt7e6SZueThZoNCOuQ4+MZXTEGH/9JSJulZ6IEW+zHI5sQm0rz70aX2OxMB7Pyfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=malat.biz; spf=none smtp.mailfrom=malat.biz; dkim=pass (2048-bit key) header.d=malat-biz.20230601.gappssmtp.com header.i=@malat-biz.20230601.gappssmtp.com header.b=qoSK6Ir6; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=malat.biz
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=malat.biz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=malat-biz.20230601.gappssmtp.com header.i=@malat-biz.20230601.gappssmtp.com header.b="qoSK6Ir6"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7c559b3eb0bso195574685a.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 May 2025 07:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20230601.gappssmtp.com; s=20230601; t=1748355723; x=1748960523; darn=vger.kernel.org;
        h=to:subject:message-id:date:mime-version:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O9GJlCORK/vk95UgyIhKqp4MvMY3ulWZUQaTIUKdgko=;
        b=qoSK6Ir6HmbGcXb+b78ag0iAFcaCQv+tQfQmg3CSigaB3bYO55sXfO8Oh2WpwoZmGa
         WxYHL3bBE7fTTgiVD6PTEr0MUl3iZqbbQQ0dsF2xjXllBCmmBJnVy51uX9mpUrpdcwIP
         AHIXEIa8AyFBuXw0Qcp+XaUj8ckWENE/NqzvTl2Q/cHfFWqI1hSva27qxeU0rJSTD4kj
         2mitg+cKcKcyOe84fWDVJTDwdct/G/Z/JEzyGeKzBIDsiKnovFyHtbWqUD1PypDbO9PL
         iVEVw0ghUJRcZfwvBHim9vLs81m8jsm3vmL8p1NcNuKF/L6c9H3dOaIme3NjPRshZ5I1
         M6xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748355723; x=1748960523;
        h=to:subject:message-id:date:mime-version:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O9GJlCORK/vk95UgyIhKqp4MvMY3ulWZUQaTIUKdgko=;
        b=mhq5Bv/AStlx9btg8qFnf0fp/Qw1wtx9TDlE2xtsxkGb4ivKglTg5z7l4sj0G2ECNL
         kf74Egc2huh+tuFr21KjMVozzRXDG8cFeiSJ+FhnC6jZpJ1S4Quw1gFXNFLTcMQrNHsw
         c957/QtsF8JD7K78z2LSlt4Kk0AKwQ0+cjxGnkbXqHrkV4nO/eZ3Wfn7XKYBghdqzRwn
         oI1/c9ltHdjETOLZ3GNfTaXOAWqPz8DXWVHWGU54n4JKr8X7auMcV0C0qOOCABk7s9bU
         4yXxXRb3s5GtFNV377wmcUADJiY1oplcfxccpgn6Y+dppcdFxGDUEQHsCL1s2kfef/Ap
         7Cag==
X-Gm-Message-State: AOJu0YwIp4dXKh/xW+7MewjIH/sOurRvbpRLL1rFZmoOaiooFdv7vzjv
	B5DReOrYfY+B26TdIA/xNNPzSfRxj+wpQ6M6YcGg8HLNw4AgujBVtkA5k2KvQixtfiSIZ1M/6SE
	mq3U9P0FNnMy+T/onBuGBRpeQvil0ApAHjVpQB6l9Ak27q1kTWMdNRg==
X-Gm-Gg: ASbGncsu4tWxtY4BjZXcZ0H3+0s5b8wOxjxQCZ9GvbHov1+OChos8J5wHh4vx8VSIWn
	5GnpkKW2Ie6qgIuorm2/iCKW6orSFfM3qRXW9sYTaDsRV9Z5Q4XnhZ6ZGfdHe7tjHHEDucy52z5
	baIl3T1h+I8EjeAbRNFSke8UpsqLxFteA=
X-Google-Smtp-Source: AGHT+IH3QhlHUKZOuc+zFI1QL/gi284uq+uvJxmyky7t+bV0NHtYcPLDaBxDsIZ4Hcymc3sMOEG2YLT5g4zC/ooZeFA=
X-Received: by 2002:a05:620a:3194:b0:7c5:9c12:fc8 with SMTP id
 af79cd13be357-7ceecbe06b6mr1832617985a.38.1748355723208; Tue, 27 May 2025
 07:22:03 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 May 2025 09:22:01 -0500
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 May 2025 09:22:01 -0500
From: Petr Malat <oss@malat.biz>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 27 May 2025 09:22:01 -0500
X-Gm-Features: AX0GCFvjdLOfeXprLZG4ni_k0n78XXhjSn7dgKPSycDwaMlZXT3uHBB3tJdgxkQ
Message-ID: <CANMuvJnWm0RpUCw+hMeqzGCig8hydUGYBZWKaNM44zGOM8jFqg@mail.gmail.com>
Subject: libtracecmd: tracecmd_filter_add filters unrelated events
To: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,
when I attach a filter "subsys/event:field==val" using
tracecmd_filter_add(), it filters out all other events as well and
not just the event, for which the filter is relevant. I want to ask if
this is intentional or a bug. I expected the function to mirror filter
feature of ftrace, where setting a filter in events/subsys/event/filter
has no effect on other events than subsys/event.

Per event filtering is done using tracecmd_follow_event(), so the
current behavior of tracecmd_filter_add() is redundant to it and
prevents creating per event filters without using custom callbacks.

If this behavior is not intentional, I can prepare a patch to not filter
out events where none of the fillers is applicable to.
BR,
  Petr
