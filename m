Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA79195FF3
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594895; cv=none; b=fF4blXOY+gwnowczF3yw4dBuUI82pOh/G98XU0C8BwZboNTPG9/xaEhUxZ4h/ujxowH23/gn/L7HpkpKkx9YNtLw4J5IYCHUJ2zq+X/lnhqTlvIBqbV/Tc1K0EaKS72u4sdB7TYlgv17ARBEh70W2Q77bTrzoI5ApvOWP5QciYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594895; c=relaxed/simple;
	bh=YPzNj/PUaAGdpiCZwkmvpo/YxyhRxFlbdyE1VCmRJis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcS07OMMiWhDM9aoN89uSalanwg3Thg0U1SFLUyZkXqsLPiXya99iWqmgHAgDcjSFfNaGyXxRggHx1Wv5vZSaUnDbSd1okMvX+er+wBfpc4LFr39QgQt+4B5Dih0TRDV7Lqs6Yw2iOUOZvQ87183w5SVfEq1UTCGAOjOhmMHckA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fejpiy6F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fejpiy6F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=spax7Yod4Fqxbqlr5kfahKesUEd3qUBg9Z2+ohgV7Qo=;
	b=fejpiy6Fmj5/FZI350FT9rOEAiycItDw+1lFRUsvEAb4KOrs6yXEh1sXp+XVj9GJAuv79H
	pL91bIfrK+Cf+7QaLvceomD5s5IZpqWHADh4LyKvicCyN2PMwsSZh+xw7H3h4sMhtxqnTF
	rFFJPv1CouZLzVLJTCTZ4rpX+4++5uM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-389-e6PNsXV2P0C_lTHyP3vRPw-1; Wed,
 05 Jun 2024 09:41:31 -0400
X-MC-Unique: e6PNsXV2P0C_lTHyP3vRPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0A831C05122;
	Wed,  5 Jun 2024 13:41:30 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id DE5C140D1B68;
	Wed,  5 Jun 2024 13:41:28 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:28 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 08/38] trace-cmd lib: prevent a memory leak in create_event_list_item()
Date: Wed,  5 Jun 2024 15:40:23 +0200
Message-ID: <20240605134054.2626953-9-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Free ptr if malloc() fails.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 59498edc..4a9ecc5d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -955,7 +955,8 @@ create_event_list_item(struct tracecmd_output *handle,
 	free(str);
 	return;
  err_mem:
-	 tracecmd_warning("Insufficient memory");
+	free(ptr);
+	tracecmd_warning("Insufficient memory");
 }
 
 static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
-- 
2.44.0

